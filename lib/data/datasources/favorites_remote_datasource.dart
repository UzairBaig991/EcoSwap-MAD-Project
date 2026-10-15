import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';

abstract class FavoritesRemoteDataSource {
  Future<void> addFavorite(String userId, String listingId);
  Future<void> removeFavorite(String userId, String listingId);
  Stream<List<String>> getFavoriteIdsStream(String userId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore;

  FavoritesRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addFavorite(String userId, String listingId) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('listings')
          .doc(listingId)
          .set({'addedAt': Timestamp.now()});

      // Increment favorite count on listing
      await _firestore.collection('listings').doc(listingId).update({
        'favoriteCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw ServerException('Failed to add favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(String userId, String listingId) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('listings')
          .doc(listingId)
          .delete();

      await _firestore.collection('listings').doc(listingId).update({
        'favoriteCount': FieldValue.increment(-1),
      });
    } catch (e) {
      throw ServerException('Failed to remove favorite: ${e.toString()}');
    }
  }

  @override
  Stream<List<String>> getFavoriteIdsStream(String userId) {
    return _firestore
        .collection('favorites')
        .doc(userId)
        .collection('listings')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}
