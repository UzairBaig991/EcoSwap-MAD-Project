import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/network/notification_service.dart';
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

  Future<void> _notifyWelcome(String providerName) async {
    try {
      if (!kIsWeb) {
        await NotificationService.instance.showLocalNotification(
          title: 'Welcome to EcoSwap! 🌱',
          body: 'You have successfully signed in with $providerName. Start swapping sustainably today!',
        );
      }
    } catch (_) {}
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await _notifyWelcome('Email');
      return cred;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed. Please check your credentials.', code: e.code);
    } catch (e) {
      throw const AuthException('Authentication failed. Please try again.');
    }
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _notifyWelcome('Email Registration');
      return cred;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed.', code: e.code);
    } catch (e) {
      throw const AuthException('Registration failed. Please try again.');
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      UserCredential cred;
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        cred = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
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

        cred = await _firebaseAuth.signInWithCredential(credential);
      }

      await _notifyWelcome('Google Account');
      return cred;
    } on FirebaseAuthException catch (e) {
      final code = e.code;
      final msg = e.message;
      if (code == 'popup-closed-by-user' || code == 'cancelled') {
        throw const AuthException('Google Sign-In popup was closed.');
      }
      throw AuthException(msg != null && msg.isNotEmpty ? msg : 'Google Sign-In failed ($code).', code: code);
    } catch (e) {
      final errText = e.toString().toLowerCase();
      if (errText.contains('popup_closed') || errText.contains('canceled') || errText.contains('cancelled')) {
        throw const AuthException('Google Sign-In was cancelled.');
      }
      throw AuthException('Google sign-in error: ${e.toString().replaceAll('Assertion failed:', '').replaceAll('PlatformException(', '').replaceAll(')', '')}');
    }
  }

  @override
  Future<UserCredential> signInWithFacebook() async {
    try {
      UserCredential cred;
      final facebookProvider = FacebookAuthProvider();
      facebookProvider.addScope('email');
      facebookProvider.addScope('public_profile');

      if (kIsWeb) {
        cred = await _firebaseAuth.signInWithPopup(facebookProvider);
      } else {
        cred = await _firebaseAuth.signInWithProvider(facebookProvider);
      }

      await _notifyWelcome('Facebook Account');
      return cred;
    } on FirebaseAuthException catch (e) {
      final code = e.code;
      final msg = e.message;
      if (code == 'popup-closed-by-user' || code == 'cancelled') {
        throw const AuthException('Facebook Sign-In popup was closed.');
      }
      if (code == 'operation-not-allowed' || (msg != null && msg.contains('disabled'))) {
        throw const AuthException('Facebook Sign-In is currently disabled in your Firebase Console. You can sign in instantly with Google or Email!');
      }
      throw AuthException(msg != null && msg.isNotEmpty ? msg : 'Facebook Sign-In failed ($code).', code: code);
    } catch (e) {
      throw const AuthException('Facebook Sign-In is disabled in Firebase Console. Please sign in with Google or Email!');
    }
  }

  @override
  Future<UserCredential> signInAnonymously() async {
    try {
      final cred = await _firebaseAuth.signInAnonymously();
      await _notifyWelcome('Guest Explorer');
      return cred;
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
