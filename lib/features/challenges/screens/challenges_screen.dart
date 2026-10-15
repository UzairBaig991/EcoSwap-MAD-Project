import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_challenge_model.dart';
import '../../../data/models/user_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/challenge_provider.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Challenges & Ranks'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(icon: Icon(Icons.stars_rounded), text: 'Weekly Challenges'),
            Tab(icon: Icon(Icons.leaderboard_rounded), text: 'City Leaderboard'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WeeklyChallengesTab(),
          CityLeaderboardTab(),
        ],
      ),
    );
  }
}

class WeeklyChallengesTab extends ConsumerWidget {
  const WeeklyChallengesTab({super.key});

  IconData _getChallengeIcon(String? iconName) {
    switch (iconName) {
      case 'inventory_2_rounded':
        return Icons.inventory_2_rounded;
      case 'swap_horizontal_circle_rounded':
        return Icons.swap_horizontal_circle_rounded;
      case 'eco_rounded':
        return Icons.eco_rounded;
      default:
        return Icons.stars_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final challengesAsync = ref.watch(weeklyChallengesStreamProvider);
    final userChallengesAsync = ref.watch(userChallengesStreamProvider);

    final userChallenges = userChallengesAsync.asData?.value ?? [];

    return challengesAsync.when(
      data: (challenges) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];

            UserChallengeModel? userChallenge;
            for (final uc in userChallenges) {
              if (uc.challengeId == challenge.id) {
                userChallenge = uc;
                break;
              }
            }

            final isCompleted = userChallenge?.completed ?? false;
            final currentProgress = isCompleted ? challenge.targetValue : (userChallenge?.progress ?? 1.0);
            final progressPercentage = (currentProgress / challenge.targetValue).clamp(0.0, 1.0);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getChallengeIcon(challenge.iconName),
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                challenge.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                challenge.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${challenge.rewardPoints} pts',
                            style: const TextStyle(
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progressPercentage,
                              minHeight: 8,
                              backgroundColor: AppColors.primaryContainer.withOpacity(0.5),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${currentProgress.toInt()} / ${challenge.targetValue.toInt()}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Claim Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isCompleted
                            ? null
                            : () async {
                                final success = await ref
                                    .read(challengeControllerProvider.notifier)
                                    .claimReward(challenge.id, challenge.rewardPoints);
                                if (success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Challenge Completed! +${challenge.rewardPoints} Eco Points added! 🎉'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                }
                              },
                        child: Text(isCompleted ? 'Completed ✓' : 'Claim Reward (+${challenge.rewardPoints} pts)'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error loading challenges: $err')),
    );
  }
}

class CityLeaderboardTab extends ConsumerWidget {
  const CityLeaderboardTab({super.key});

  Widget _buildPodiumAvatar(UserModel user, int rank, Color borderColor, String emoji) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 3),
              ),
              child: CircleAvatar(
                radius: rank == 1 ? 36 : 28,
                backgroundColor: AppColors.primaryContainer,
                backgroundImage: (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                    ? CachedNetworkImageProvider(user.photoUrl!)
                    : null,
                child: (user.photoUrl == null || user.photoUrl!.isEmpty)
                    ? Text(
                        user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : 'E',
                        style: TextStyle(
                          fontSize: rank == 1 ? 24 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          user.displayName.split(' ').first,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          '${user.ecoScore} pts',
          style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final leaderboardAsync = ref.watch(leaderboardStreamProvider);
    final currentUser = ref.watch(currentUserModelProvider).asData?.value;

    return leaderboardAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text('No leaderboard rankings yet'));
        }

        final top3 = users.take(3).toList();
        final rest = users.skip(3).toList();

        return Column(
          children: [
            // Top 3 Podium Card
            if (top3.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (top3.length >= 2) _buildPodiumAvatar(top3[1], 2, Colors.grey.shade400, '🥈'),
                    if (top3.isNotEmpty) _buildPodiumAvatar(top3[0], 1, Colors.amber, '🥇'),
                    if (top3.length >= 3) _buildPodiumAvatar(top3[2], 3, Colors.brown.shade300, '🥉'),
                  ],
                ),
              ),

            // Rankings List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: rest.length,
                itemBuilder: (context, index) {
                  final u = rest[index];
                  final rank = index + 4;
                  final isMe = u.uid == currentUser?.uid;

                  return Container(
                    color: isMe ? AppColors.primaryContainer.withOpacity(0.4) : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: isMe ? AppColors.primary : theme.colorScheme.surfaceVariant,
                        child: Text(
                          '#$rank',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.white : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      title: Text(
                        u.displayName,
                        style: TextStyle(
                          fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('${u.totalCo2Saved.toStringAsFixed(1)} kg CO₂ saved'),
                      trailing: Text(
                        '${u.ecoScore} pts',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
