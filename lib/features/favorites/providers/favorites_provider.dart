import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/favorites_repository.dart';
import '../../../data/repositories/favorites_repository_impl.dart';
import '../../../data/models/listing_model.dart';
import '../../auth/providers/auth_provider.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl();
});

final favoriteIdsStreamProvider = StreamProvider<List<String>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.asData?.value?.uid;
  if (userId == null) return Stream.value([]);

  final repo = ref.watch(favoritesRepositoryProvider);
  return repo.getFavoriteIdsStream(userId);
});

final offlineFavoritesProvider = Provider<List<ListingModel>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return repo.getOfflineFavorites();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoritesRepository _repository;
  final Ref _ref;

  FavoritesNotifier(this._repository, this._ref) : super({});

  void updateFavoriteIds(List<String> ids) {
    state = Set.from(ids);
  }

  Future<void> toggleFavorite(ListingModel listing) async {
    final user = _ref.read(authStateProvider).asData?.value;
    if (user == null) return;

    await _repository.toggleFavorite(user.uid, listing);

    if (state.contains(listing.id)) {
      state = Set.from(state)..remove(listing.id);
    } else {
      state = Set.from(state)..add(listing.id);
    }
  }
}

final favoritesControllerProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  final notifier = FavoritesNotifier(repo, ref);

  ref.listen<AsyncValue<List<String>>>(favoriteIdsStreamProvider, (previous, next) {
    if (next.asData != null) {
      notifier.updateFavoriteIds(next.asData!.value);
    }
  });

  return notifier;
});
