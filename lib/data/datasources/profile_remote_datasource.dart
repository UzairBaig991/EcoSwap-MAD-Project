import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/listing_model.dart';
import '../../core/network/cloudinary_service.dart';
import '../../core/errors/exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateUserProfile(UserModel userModel);
  Future<String> uploadProfileImageBytes(String userId, Uint8List imageBytes);
  Stream<List<ListingModel>> getUserListings(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> updateUserProfile(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImageBytes(String userId, Uint8List imageBytes) async {
    try {
      // 1. Upload via CloudinaryService
      final photoUrl = await CloudinaryService.uploadImageBytes(imageBytes);

      final finalUrl = (photoUrl != null && photoUrl.isNotEmpty)
          ? photoUrl
          : 'data:image/jpeg;base64,${base64Encode(imageBytes)}';

      // 2. Save directly to Firestore user document
      await _firestore.collection('users').doc(userId).update({
        'photoUrl': finalUrl,
        'updatedAt': Timestamp.now(),
      });

      return finalUrl;
    } catch (e) {
      final fallbackUrl = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';
      try {
        await _firestore.collection('users').doc(userId).update({
          'photoUrl': fallbackUrl,
          'updatedAt': Timestamp.now(),
        });
      } catch (_) {}
      return fallbackUrl;
    }
  }

  @override
  Stream<List<ListingModel>> getUserListings(String userId) {
    return _firestore
        .collection('listings')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromFirestore(doc))
            .toList());
  }
}
