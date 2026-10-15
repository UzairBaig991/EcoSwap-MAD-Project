import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/challenge_repository.dart';
import '../../../data/repositories/challenge_repository_impl.dart';
import '../../../data/models/challenge_model.dart';
import '../../../data/models/user_challenge_model.dart';
import '../../../data/models/user_model.dart';
import '../../auth/providers/auth_provider.dart';

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepositoryImpl();
});

final weeklyChallengesStreamProvider = StreamProvider<List<ChallengeModel>>((ref) {
  final repo = ref.watch(challengeRepositoryProvider);
  return repo.getWeeklyChallengesStream();
});

final userChallengesStreamProvider = StreamProvider<List<UserChallengeModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.asData?.value?.uid;
  if (userId == null) return Stream.value([]);

  final repo = ref.watch(challengeRepositoryProvider);
  return repo.getUserChallengesStream(userId);
});

final leaderboardStreamProvider = StreamProvider<List<UserModel>>((ref) {
  final user = ref.watch(currentUserModelProvider).asData?.value;
  final city = user?.location.city ?? 'San Francisco';

  final repo = ref.watch(challengeRepositoryProvider);
  return repo.getLeaderboardStream(city);
});

class ChallengeNotifier extends StateNotifier<AsyncValue<void>> {
  final ChallengeRepository _repository;
  final Ref _ref;

  ChallengeNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<bool> claimReward(String challengeId, int rewardPoints) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(authStateProvider).asData?.value;
      if (user == null) return false;

      await _repository.claimReward(user.uid, challengeId, rewardPoints);
      state = const AsyncValue.data(null);
      _ref.invalidate(currentUserModelProvider);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final challengeControllerProvider =
    StateNotifierProvider<ChallengeNotifier, AsyncValue<void>>((ref) {
  return ChallengeNotifier(ref.watch(challengeRepositoryProvider), ref);
});
