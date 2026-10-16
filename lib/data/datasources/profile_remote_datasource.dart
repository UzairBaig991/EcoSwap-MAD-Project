import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/listing_model.dart';
import '../../core/network/cloudinary_service.dart';
import '../../core/errors/exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateUserProfile(UserModel userModel);
  Future<String> uploadProfileImage(String userId, File imageFile);
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
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      // 1. Try Free Cloudinary Upload
      final cloudinaryUrl = await CloudinaryService.uploadImage(imageFile);
      if (cloudinaryUrl != null && cloudinaryUrl.isNotEmpty) {
        return cloudinaryUrl;
      }

      // 2. Fallback: Base64 Data URI string
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      throw StorageException('Failed to process profile photo: ${e.toString()}');
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
