import '../models/listing_model.dart';

abstract class FavoritesRepository {
  Future<void> toggleFavorite(String userId, ListingModel listing);
  List<ListingModel> getOfflineFavorites();
  Stream<List<String>> getFavoriteIdsStream(String userId);
  bool isFavoriteLocal(String listingId);
}
