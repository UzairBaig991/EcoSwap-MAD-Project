import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithFacebook();
  Future<UserCredential> signInAnonymously();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<UserModel?> getUserProfile(String uid);
  Future<void> createUserProfile(UserModel user);
  Future<void> updateUserProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  // Web Client ID from google-services.json (client_type 3)
  static const String _webClientId = '892620643197-2bvofdii5afgcdukmemgvs9tqi5bdhs5.apps.googleusercontent.com';

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId: kIsWeb ? _webClientId : null,
              serverClientId: kIsWeb ? null : _webClientId,
            ),
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed. Please check your credentials.', code: e.code);
    } catch (e) {
      throw const AuthException('Authentication failed. Please try again.');
    }
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed.', code: e.code);
    } catch (e) {
      throw const AuthException('Registration failed. Please try again.');
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        return await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // Native Google Sign-In for Android & iOS
        await _googleSignIn.signOut();

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw const AuthException('Google Sign-In was cancelled.');
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _firebaseAuth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      final code = e.code;
      final msg = e.message;
      if (code == 'popup-closed-by-user' || code == 'cancelled') {
        throw const AuthException('Google Sign-In popup was closed.');
      }
      if (code == 'unauthorized-domain') {
        throw const AuthException('localhost domain is not authorized in Firebase Auth Settings.');
      }
      throw AuthException(msg != null && msg.isNotEmpty ? msg : 'Google Sign-In failed ($code).', code: code);
    } catch (e) {
      final errText = e.toString().toLowerCase();
      if (errText.contains('popup_closed') || errText.contains('canceled') || errText.contains('cancelled')) {
        throw const AuthException('Google Sign-In popup was closed.');
      }
      throw AuthException('Google Sign-In error: ${e.toString()}');
    }
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    try {
      final facebookProvider = FacebookAuthProvider();
      return await _firebaseAuth.signInWithProvider(facebookProvider);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Facebook Sign-In failed.', code: e.code);
    } catch (e) {
      throw const AuthException('Facebook sign-in requires Facebook App ID configuration in Firebase Console. You can sign in with Email!');
    }
  }

  @override
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _firebaseAuth.signInAnonymously();
    } catch (e) {
      throw const AuthException('Guest sign in failed. Please use Email Sign In.');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Failed to send password reset email.', code: e.code);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        if (!kIsWeb) _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toFirestore());
    } catch (e) {
      // Non-blocking fallback
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toFirestore());
    } catch (e) {
      // Non-blocking fallback
    }
  }
}
