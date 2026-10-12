import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/listing_repository.dart';
import '../../../data/repositories/listing_repository_impl.dart';
import '../../../data/models/listing_model.dart';
import '../../auth/providers/auth_provider.dart';

final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  return ListingRepositoryImpl();
});

final singleListingProvider = FutureProvider.family<ListingModel?, String>((ref, id) async {
  final repo = ref.watch(listingRepositoryProvider);
  return await repo.getListingById(id);
});

enum ListingOperationStatus { initial, loading, success, error }

class ListingOperationState {
  final ListingOperationStatus status;
  final String? errorMessage;
  final String? createdListingId;

  const ListingOperationState({
    this.status = ListingOperationStatus.initial,
    this.errorMessage,
    this.createdListingId,
  });

  ListingOperationState copyWith({
    ListingOperationStatus? status,
    String? errorMessage,
    String? createdListingId,
  }) {
    return ListingOperationState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdListingId: createdListingId ?? this.createdListingId,
    );
  }
}

final listingControllerProvider = StateNotifierProvider<ListingController, ListingOperationState>((ref) {
  return ListingController(ref.watch(listingRepositoryProvider), ref);
});

class ListingController extends StateNotifier<ListingOperationState> {
  final ListingRepository _repository;
  final Ref _ref;

  ListingController(this._repository, this._ref) : super(const ListingOperationState());

  Future<bool> createListing({
    required String title,
    required String description,
    required String category,
    required String condition,
    required String type,
    double? price,
    required List<File> imageFiles,
    required double lat,
    required double lng,
    required String address,
  }) async {
    state = state.copyWith(status: ListingOperationStatus.loading, errorMessage: null);

    try {
      final userModel = await _ref.read(currentUserModelProvider.future);
      if (userModel == null) throw Exception('User not logged in');

      final newListing = ListingModel(
        id: '',
        ownerId: userModel.uid,
        ownerName: userModel.displayName,
        ownerPhotoUrl: userModel.photoUrl,
        title: title,
        description: description,
        category: category,
        condition: condition,
        type: type,
        price: price,
        images: const [],
        location: ListingLocation(
          lat: lat,
          lng: lng,
          geohash: '',
          address: address,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final listingId = await _repository.createListing(newListing, imageFiles);

      state = state.copyWith(
        status: ListingOperationStatus.success,
        createdListingId: listingId,
      );
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ListingOperationStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateListing({
    required ListingModel currentListing,
    required String title,
    required String description,
    required String category,
    required String condition,
    required String type,
    double? price,
    required List<File> newImageFiles,
    required List<String> retainedImages,
  }) async {
    state = state.copyWith(status: ListingOperationStatus.loading, errorMessage: null);

    try {
      final updatedListing = currentListing.copyWith(
        title: title,
        description: description,
        category: category,
        condition: condition,
        type: type,
        price: price,
        images: retainedImages,
        updatedAt: DateTime.now(),
      );

      await _repository.updateListing(updatedListing, newImageFiles);

      state = state.copyWith(status: ListingOperationStatus.success);
      _ref.invalidate(singleListingProvider(currentListing.id));
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ListingOperationStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> deleteListing(String listingId) async {
    state = state.copyWith(status: ListingOperationStatus.loading, errorMessage: null);

    try {
      await _repository.deleteListing(listingId);
      state = state.copyWith(status: ListingOperationStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ListingOperationStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> markStatus(String listingId, String status, {String? claimedByUserId}) async {
    state = state.copyWith(status: ListingOperationStatus.loading, errorMessage: null);

    try {
      await _repository.updateListingStatus(listingId, status, claimedByUserId: claimedByUserId);
      state = state.copyWith(status: ListingOperationStatus.success);
      _ref.invalidate(singleListingProvider(listingId));
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ListingOperationStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}
