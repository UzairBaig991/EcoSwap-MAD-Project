import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password, String displayName);
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInAnonymously();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<UserModel?> getCurrentUserProfile();
  Future<void> updateUserProfile(UserModel user);
}
