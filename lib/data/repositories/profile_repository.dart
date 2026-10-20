import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/listing_model.dart';

abstract class ProfileRepository {
  Future<void> updateUserProfile(UserModel userModel);
  Future<String> uploadProfileImageBytes(String userId, Uint8List imageBytes);
  Stream<List<ListingModel>> getUserListings(String userId);
}
