import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserModelProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.asData?.value;
  if (user == null) return null;

  final repo = ref.watch(authRepositoryProvider);
  return await repo.getCurrentUserProfile();
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider), ref);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref) : super(const AuthState());

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final user = await _repository.signInWithEmailAndPassword(email, password);
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        _ref.invalidate(currentUserModelProvider);
        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to sign in. User not found.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final user = await _repository.signUpWithEmailAndPassword(email, password, displayName);
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        _ref.invalidate(currentUserModelProvider);
        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to create account.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final user = await _repository.signInWithGoogle();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        _ref.invalidate(currentUserModelProvider);
        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Google Sign-In failed.',
        );
        return false;
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: msg.contains('cancelled') ? 'Google Sign-In was cancelled.' : msg,
      );
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final user = await _repository.signInAnonymously();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
        _ref.invalidate(currentUserModelProvider);
        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Guest sign in failed.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      await _repository.sendPasswordResetEmail(email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    await _repository.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
    _ref.invalidate(currentUserModelProvider);
  }
}
