import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';
import '../../core/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl();

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  User? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _remoteDataSource.signInWithEmailAndPassword(email, password);
    final user = credential.user;
    if (user == null) return null;

    final profile = await _remoteDataSource.getUserProfile(user.uid);
    if (profile != null) return profile;

    // Create default profile if missing
    final newProfile = UserModel(
      uid: user.uid,
      email: user.email ?? email,
      displayName: user.displayName ?? 'EcoSwapper',
      photoUrl: user.photoURL,
      location: const UserLocation(
        lat: AppConstants.defaultLatitude,
        lng: AppConstants.defaultLongitude,
        city: 'San Francisco',
        geohash: '9q8yy',
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _remoteDataSource.createUserProfile(newProfile);
    return newProfile;
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _remoteDataSource.signUpWithEmailAndPassword(email, password);
    final user = credential.user!;

    await user.updateDisplayName(displayName);

    final newProfile = UserModel(
      uid: user.uid,
      email: email,
      displayName: displayName,
      photoUrl: null,
      location: const UserLocation(
        lat: AppConstants.defaultLatitude,
        lng: AppConstants.defaultLongitude,
        city: 'San Francisco',
        geohash: '9q8yy',
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _remoteDataSource.createUserProfile(newProfile);
    return newProfile;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final credential = await _remoteDataSource.signInWithGoogle();
    final user = credential.user!;

    final existingProfile = await _remoteDataSource.getUserProfile(user.uid);
    if (existingProfile != null) return existingProfile;

    final newProfile = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'EcoSwapper',
      photoUrl: user.photoURL,
      location: const UserLocation(
        lat: AppConstants.defaultLatitude,
        lng: AppConstants.defaultLongitude,
        city: 'San Francisco',
        geohash: '9q8yy',
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _remoteDataSource.createUserProfile(newProfile);
    return newProfile;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  @override
  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;
    return await _remoteDataSource.getUserProfile(user.uid);
  }

  @override
  Future<void> updateUserProfile(UserModel userModel) async {
    await _remoteDataSource.updateUserProfile(userModel);
  }
}
