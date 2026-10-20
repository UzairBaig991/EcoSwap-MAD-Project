import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

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
    final userCredential = await _remoteDataSource.signInWithEmailAndPassword(email, password);
    final user = userCredential.user;
    if (user == null) return null;

    var profile = await _remoteDataSource.getUserProfile(user.uid);
    if (profile == null) {
      profile = UserModel(
        uid: user.uid,
        email: user.email ?? email,
        displayName: user.displayName ?? email.split('@').first,
        photoUrl: user.photoURL,
        location: const UserLocation(lat: 0.0, lng: 0.0, city: 'Unknown', geohash: ''),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _remoteDataSource.createUserProfile(profile);
    }
    return profile;
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    final userCredential = await _remoteDataSource.signUpWithEmailAndPassword(email, password);
    final user = userCredential.user;
    if (user == null) return null;

    final newProfile = UserModel(
      uid: user.uid,
      email: email,
      displayName: displayName,
      photoUrl: user.photoURL,
      location: const UserLocation(lat: 0.0, lng: 0.0, city: 'Unknown', geohash: ''),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _remoteDataSource.createUserProfile(newProfile);
    return newProfile;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    final userCredential = await _remoteDataSource.signInWithGoogle();
    final user = userCredential.user;
    if (user == null) return null;

    var profile = await _remoteDataSource.getUserProfile(user.uid);
    if (profile == null) {
      profile = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'Eco Swapper',
        photoUrl: user.photoURL,
        location: const UserLocation(lat: 0.0, lng: 0.0, city: 'Unknown', geohash: ''),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _remoteDataSource.createUserProfile(profile);
    }
    return profile;
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    final userCredential = await _remoteDataSource.signInAnonymously();
    final user = userCredential.user;
    if (user == null) return null;

    var profile = await _remoteDataSource.getUserProfile(user.uid);
    if (profile == null) {
      profile = UserModel(
        uid: user.uid,
        email: '',
        displayName: 'Guest Swapper',
        location: const UserLocation(lat: 0.0, lng: 0.0, city: 'Unknown', geohash: ''),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _remoteDataSource.createUserProfile(profile);
    }
    return profile;
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
  Future<UserModel?> getCurrentUserProfile() async {
    final user = _remoteDataSource.currentUser;
    if (user == null) return null;
    return await _remoteDataSource.getUserProfile(user.uid);
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _remoteDataSource.updateUserProfile(user);
  }
}
