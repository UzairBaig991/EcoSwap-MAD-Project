import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dart_geohash/dart_geohash.dart';

import '../models/listing_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/carbon_calculator.dart';
import '../../core/errors/exceptions.dart';

abstract class ListingRemoteDataSource {
  Future<String> createListing(ListingModel listing, List<File> imageFiles);
  Future<void> updateListing(ListingModel listing, List<File> newImageFiles);
  Future<void> deleteListing(String listingId);
  Future<void> updateListingStatus(String listingId, String status, {String? claimedByUserId});
  Future<ListingModel?> getListingById(String listingId);
  Stream<List<ListingModel>> getNearbyListings({
    required double lat,
    required double lng,
    required double radiusKm,
    String? category,
    String? type,
    String? condition,
    String? searchQuery,
  });
}

class ListingRemoteDataSourceImpl implements ListingRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final GeoHasher _geoHasher;

  ListingRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _geoHasher = GeoHasher();

  Future<File> _compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
      final splitted = filePath.substring(0, (lastIndex >= 0 ? lastIndex : filePath.length));
      final outPath = "${splitted}_out.jpg";

      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (compressedXFile != null) {
        return File(compressedXFile.path);
      }
      return file;
    } catch (_) {
      return file;
    }
  }

  Future<List<String>> _uploadImages(String listingId, List<File> files) async {
    final List<String> imageUrls = [];

    for (int i = 0; i < files.length; i++) {
      final compressedFile = await _compressImage(files[i]);

      try {
        final ref = _storage
            .ref()
            .child('listing_images/$listingId/img_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = await ref.putFile(compressedFile);
        final url = await uploadTask.ref.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        // Fallback: Store compressed image as Base64 Data URI if Firebase Storage bucket is offline
        final bytes = await compressedFile.readAsBytes();
        final base64String = base64Encode(bytes);
        imageUrls.add('data:image/jpeg;base64,$base64String');
      }
    }

    return imageUrls;
  }

  @override
  Future<String> createListing(ListingModel listing, List<File> imageFiles) async {
    try {
      final docRef = _firestore.collection('listings').doc();
      final listingId = docRef.id;

      // Calculate geohash
      final geohash = _geoHasher.encode(listing.location.lng, listing.location.lat, precision: 6);

      // Upload or encode images
      final imageUrls = await _uploadImages(listingId, imageFiles);

      // Estimate CO2 saved based on category using CarbonCalculator
      final co2Estimate = CarbonCalculator.estimateCategorySavings(listing.category);

      final finalListing = listing.copyWith(
        id: listingId,
        images: imageUrls,
        carbonSavedEstimate: co2Estimate,
        location: listing.location.copyWith(geohash: geohash),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(finalListing.toFirestore());

      // Award points to creator (+10 points for listing)
      await _firestore.collection('users').doc(listing.ownerId).update({
        'ecoScore': FieldValue.increment(AppConstants.pointsPerListingCreated),
      });

      return listingId;
    } catch (e) {
      throw ServerException('Failed to create listing: ${e.toString()}');
    }
  }

  @override
  Future<void> updateListing(ListingModel listing, List<File> newImageFiles) async {
    try {
      List<String> updatedImages = List.from(listing.images);

      if (newImageFiles.isNotEmpty) {
        final uploaded = await _uploadImages(listing.id, newImageFiles);
        updatedImages.addAll(uploaded);
      }

      final geohash = _geoHasher.encode(listing.location.lng, listing.location.lat, precision: 6);

      final updated = listing.copyWith(
        images: updatedImages,
        location: listing.location.copyWith(geohash: geohash),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('listings').doc(listing.id).update(updated.toFirestore());
    } catch (e) {
      throw ServerException('Failed to update listing: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteListing(String listingId) async {
    try {
      await _firestore.collection('listings').doc(listingId).update({
        'status': 'Deleted',
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw ServerException('Failed to delete listing: ${e.toString()}');
    }
  }

  @override
  Future<void> updateListingStatus(
    String listingId,
    String status, {
    String? claimedByUserId,
  }) async {
    try {
      if (status == 'Completed') {
        // Run atomic transaction to update listing status and reward CO2 + Points to both parties
        await _firestore.runTransaction((transaction) async {
          final listingRef = _firestore.collection('listings').doc(listingId);
          final listingDoc = await transaction.get(listingRef);

          if (!listingDoc.exists) throw Exception('Listing not found');

          final listing = ListingModel.fromFirestore(listingDoc);
          final co2Saved = listing.carbonSavedEstimate;
          final ownerId = listing.ownerId;
          final finalClaimerId = claimedByUserId ?? listing.claimedByUserId;

          // 1. Update listing status
          transaction.update(listingRef, {
            'status': 'Completed',
            'updatedAt': Timestamp.now(),
            if (finalClaimerId != null) 'claimedByUserId': finalClaimerId,
          });

          // 2. Award CO2 saved + 50 Eco Points to Owner
          final ownerRef = _firestore.collection('users').doc(ownerId);
          transaction.update(ownerRef, {
            'totalCo2Saved': FieldValue.increment(co2Saved),
            'ecoScore': FieldValue.increment(AppConstants.pointsPerListingCompleted),
          });

          // 3. Award CO2 saved + 50 Eco Points to Claimer (if available)
          if (finalClaimerId != null && finalClaimerId.isNotEmpty && finalClaimerId != ownerId) {
            final claimerRef = _firestore.collection('users').doc(finalClaimerId);
            transaction.update(claimerRef, {
              'totalCo2Saved': FieldValue.increment(co2Saved),
              'ecoScore': FieldValue.increment(AppConstants.pointsPerListingCompleted),
            });
          }
        });
      } else {
        final updates = <String, dynamic>{
          'status': status,
          'updatedAt': Timestamp.now(),
        };
        if (claimedByUserId != null) {
          updates['claimedByUserId'] = claimedByUserId;
        }

        await _firestore.collection('listings').doc(listingId).update(updates);
      }
    } catch (e) {
      throw ServerException('Failed to update status: ${e.toString()}');
    }
  }

  @override
  Future<ListingModel?> getListingById(String listingId) async {
    try {
      final doc = await _firestore.collection('listings').doc(listingId).get();
      if (!doc.exists) return null;
      return ListingModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to fetch listing: ${e.toString()}');
    }
  }

  @override
  Stream<List<ListingModel>> getNearbyListings({
    required double lat,
    required double lng,
    required double radiusKm,
    String? category,
    String? type,
    String? condition,
    String? searchQuery,
  }) {
    Query query = _firestore
        .collection('listings')
        .where('status', isEqualTo: 'Active');

    if (category != null && category.isNotEmpty && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    if (type != null && type.isNotEmpty && type != 'All') {
      query = query.where('type', isEqualTo: type);
    }

    if (condition != null && condition.isNotEmpty && condition != 'All') {
      query = query.where('condition', isEqualTo: condition);
    }

    return query.snapshots().map((snapshot) {
      final listings = snapshot.docs
          .map((doc) => ListingModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      // Filter by search query if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return listings.where((item) {
          return item.title.toLowerCase().contains(q) ||
              item.description.toLowerCase().contains(q);
        }).toList();
      }

      return listings;
    });
  }
}
