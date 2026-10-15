import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/challenge_model.dart';
import '../models/user_challenge_model.dart';
import '../models/user_model.dart';
import '../../core/errors/exceptions.dart';

abstract class ChallengeRemoteDataSource {
  Stream<List<ChallengeModel>> getWeeklyChallengesStream();
  Stream<List<UserChallengeModel>> getUserChallengesStream(String userId);
  Future<void> claimReward(String userId, String challengeId, int rewardPoints);
  Stream<List<UserModel>> getLeaderboardStream(String city);
}

class ChallengeRemoteDataSourceImpl implements ChallengeRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChallengeRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ChallengeModel>> getWeeklyChallengesStream() {
    return _firestore.collection('challenges').snapshots().map((snapshot) {
      final docs = snapshot.docs;
      if (docs.isEmpty) {
        // Return default weekly challenges if Firestore database has no challenge docs created yet
        final now = DateTime.now();
        final nextWeek = now.add(const Duration(days: 7));
        return [
          ChallengeModel(
            id: 'c_list_3',
            title: 'Community Declutter',
            description: 'List 3 unused items this week to give them a second life.',
            startDate: now,
            endDate: nextWeek,
            targetType: 'listings',
            targetValue: 3.0,
            rewardPoints: 100,
            iconName: 'inventory_2_rounded',
          ),
          ChallengeModel(
            id: 'c_swap_2',
            title: 'Local Swapper',
            description: 'Complete 2 exchanges or claim items from neighbors.',
            startDate: now,
            endDate: nextWeek,
            targetType: 'exchanges',
            targetValue: 2.0,
            rewardPoints: 150,
            iconName: 'swap_horizontal_circle_rounded',
          ),
          ChallengeModel(
            id: 'c_co2_15',
            title: 'Carbon Hero',
            description: 'Save 15 kg of CO₂ emissions through reused marketplace items.',
            startDate: now,
            endDate: nextWeek,
            targetType: 'co2_saved',
            targetValue: 15.0,
            rewardPoints: 200,
            iconName: 'eco_rounded',
          ),
        ];
      }

      return docs.map((doc) => ChallengeModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<UserChallengeModel>> getUserChallengesStream(String userId) {
    return _firestore
        .collection('user_challenges')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserChallengeModel.fromFirestore(doc)).toList());
  }

  @override
  Future<void> claimReward(String userId, String challengeId, int rewardPoints) async {
    try {
      final docId = '${userId}_$challengeId';
      await _firestore.collection('user_challenges').doc(docId).set({
        'userId': userId,
        'challengeId': challengeId,
        'progress': 100.0,
        'completed': true,
        'completedAt': Timestamp.now(),
      }, SetOptions(merge: true));

      // Award reward points to user
      await _firestore.collection('users').doc(userId).update({
        'ecoScore': FieldValue.increment(rewardPoints),
      });
    } catch (e) {
      throw ServerException('Failed to claim reward: ${e.toString()}');
    }
  }

  @override
  Stream<List<UserModel>> getLeaderboardStream(String city) {
    return _firestore
        .collection('users')
        .orderBy('ecoScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }
}
