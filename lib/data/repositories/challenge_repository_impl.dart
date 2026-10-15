import '../datasources/challenge_remote_datasource.dart';
import '../models/challenge_model.dart';
import '../models/user_challenge_model.dart';
import '../models/user_model.dart';
import 'challenge_repository.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengeRemoteDataSource _remoteDataSource;

  ChallengeRepositoryImpl({ChallengeRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ChallengeRemoteDataSourceImpl();

  @override
  Stream<List<ChallengeModel>> getWeeklyChallengesStream() {
    return _remoteDataSource.getWeeklyChallengesStream();
  }

  @override
  Stream<List<UserChallengeModel>> getUserChallengesStream(String userId) {
    return _remoteDataSource.getUserChallengesStream(userId);
  }

  @override
  Future<void> claimReward(String userId, String challengeId, int rewardPoints) async {
    await _remoteDataSource.claimReward(userId, challengeId, rewardPoints);
  }

  @override
  Stream<List<UserModel>> getLeaderboardStream(String city) {
    return _remoteDataSource.getLeaderboardStream(city);
  }
}
