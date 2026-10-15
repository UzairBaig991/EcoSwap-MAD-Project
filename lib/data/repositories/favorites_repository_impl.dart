import '../datasources/favorites_local_datasource.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../models/listing_model.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;
  final FavoritesRemoteDataSource _remoteDataSource;

  FavoritesRepositoryImpl({
    FavoritesLocalDataSource? localDataSource,
    FavoritesRemoteDataSource? remoteDataSource,
  })  : _localDataSource = localDataSource ?? FavoritesLocalDataSourceImpl(),
        _remoteDataSource = remoteDataSource ?? FavoritesRemoteDataSourceImpl();

  @override
  Future<void> toggleFavorite(String userId, ListingModel listing) async {
    final isFav = _localDataSource.isFavorite(listing.id);
    if (isFav) {
      await _localDataSource.removeFavorite(listing.id);
      await _remoteDataSource.removeFavorite(userId, listing.id);
    } else {
      await _localDataSource.saveFavorite(listing);
      await _remoteDataSource.addFavorite(userId, listing.id);
    }
  }

  @override
  List<ListingModel> getOfflineFavorites() {
    return _localDataSource.getCachedFavorites();
  }

  @override
  Stream<List<String>> getFavoriteIdsStream(String userId) {
    return _remoteDataSource.getFavoriteIdsStream(userId);
  }

  @override
  bool isFavoriteLocal(String listingId) {
    return _localDataSource.isFavorite(listingId);
  }
}
