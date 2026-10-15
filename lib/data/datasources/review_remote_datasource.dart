import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../../core/errors/exceptions.dart';

abstract class ReviewRemoteDataSource {
  Future<void> submitReview(ReviewModel review);
  Stream<List<ReviewModel>> getUserReviewsStream(String userId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore _firestore;

  ReviewRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> submitReview(ReviewModel review) async {
    try {
      final docRef = _firestore.collection('reviews').doc();
      final finalReview = review.copyWith(id: docRef.id, createdAt: DateTime.now());
      await docRef.set(finalReview.toFirestore());
    } catch (e) {
      throw ServerException('Failed to submit review: ${e.toString()}');
    }
  }

  @override
  Stream<List<ReviewModel>> getUserReviewsStream(String userId) {
    return _firestore
        .collection('reviews')
        .where('toUserId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList());
  }
}
