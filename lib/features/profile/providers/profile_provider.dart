import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/listing_model.dart';
import '../../auth/providers/auth_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final userListingsStreamProvider = StreamProvider<List<ListingModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.asData?.value?.uid;
  if (userId == null) return Stream.value([]);

  final repo = ref.watch(profileRepositoryProvider);
  return repo.getUserListings(userId);
});

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final ProfileStatus status;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider), ref);
});

class ProfileController extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileController(this._repository, this._ref) : super(const ProfileState());

  Future<bool> updateProfile({
    required UserModel currentModel,
    required String displayName,
    required String bio,
    required String city,
    File? newImageFile,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);
    try {
      String? photoUrl = currentModel.photoUrl;

      if (newImageFile != null) {
        photoUrl = await _repository.uploadProfileImage(currentModel.uid, newImageFile);
      }

      final updatedLocation = currentModel.location.copyWith(city: city);

      final updatedUser = currentModel.copyWith(
        displayName: displayName,
        bio: bio,
        photoUrl: photoUrl,
        location: updatedLocation,
        updatedAt: DateTime.now(),
      );

      await _repository.updateUserProfile(updatedUser);
      state = state.copyWith(status: ProfileStatus.success);
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}
