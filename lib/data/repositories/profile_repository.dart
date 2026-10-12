import 'dart:io';
import '../models/user_model.dart';
import '../models/listing_model.dart';

abstract class ProfileRepository {
  Future<void> updateUserProfile(UserModel userModel);
  Future<String> uploadProfileImage(String userId, File imageFile);
  Stream<List<ListingModel>> getUserListings(String userId);
}
