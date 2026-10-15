import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../data/models/user_model.dart';
import '../../../core/errors/exceptions.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

final currentUserModelProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.asData?.value;
  if (user == null) return null;

  final repository = ref.watch(authRepositoryProvider);
  return await repository.getCurrentUserModel();
});

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final UserModel? userModel;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.userModel,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    UserModel? userModel,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userModel: userModel ?? this.userModel,
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider), ref);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref) : super(const AuthState());

  String _formatErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message.isNotEmpty ? error.message : 'Authentication error occurred.';
    }
    if (error is FirebaseAuthException) {
      return error.message ?? error.code;
    }
    final s = error.toString().replaceAll('Exception: ', '');
    return s.isNotEmpty ? s : 'Sign in error occurred. Please try Email Sign In or Guest mode.';
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.signInWithEmailAndPassword(email, password);
      state = state.copyWith(status: AuthStatus.success, userModel: user);
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e),
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
      final user = await _repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = state.copyWith(status: AuthStatus.success, userModel: user);
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e),
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.signInWithGoogle();
      state = state.copyWith(status: AuthStatus.success, userModel: user);
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e),
      );
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.signInWithFacebook();
      state = state.copyWith(status: AuthStatus.success, userModel: user);
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e),
      );
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.signInAnonymously();
      state = state.copyWith(status: AuthStatus.success, userModel: user);
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e),
      );
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _repository.sendPasswordResetEmail(email);
      state = state.copyWith(status: AuthStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _repository.signOut();
      state = const AuthState(status: AuthStatus.initial);
      _ref.invalidate(currentUserModelProvider);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _formatErrorMessage(e),
      );
    }
  }
}
