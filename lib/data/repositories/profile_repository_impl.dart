import 'package:flutter/foundation.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';
import '../models/listing_model.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({ProfileRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSourceImpl();

  @override
  Future<void> updateUserProfile(UserModel userModel) async {
    await _remoteDataSource.updateUserProfile(userModel);
  }

  @override
  Future<String> uploadProfileImageBytes(String userId, Uint8List imageBytes) async {
    return await _remoteDataSource.uploadProfileImageBytes(userId, imageBytes);
  }

  @override
  Stream<List<ListingModel>> getUserListings(String userId) {
    return _remoteDataSource.getUserListings(userId);
  }
}
