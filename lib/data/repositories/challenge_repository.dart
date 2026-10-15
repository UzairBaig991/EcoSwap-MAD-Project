import '../models/challenge_model.dart';
import '../models/user_challenge_model.dart';
import '../models/user_model.dart';

abstract class ChallengeRepository {
  Stream<List<ChallengeModel>> getWeeklyChallengesStream();
  Stream<List<UserChallengeModel>> getUserChallengesStream(String userId);
  Future<void> claimReward(String userId, String challengeId, int rewardPoints);
  Stream<List<UserModel>> getLeaderboardStream(String city);
}
