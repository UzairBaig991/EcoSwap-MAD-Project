import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
  Future<UserModel> signInAnonymously();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<UserModel?> getCurrentUserModel();
  Future<void> updateUserProfile(UserModel userModel);
}
