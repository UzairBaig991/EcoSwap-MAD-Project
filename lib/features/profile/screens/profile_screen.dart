import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/app_image_helper.dart';
import '../../../main.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
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

  String _getEcoLevel(int points) {
    if (points >= 500) return 'Eco Champion 🏆';
    if (points >= 250) return 'Eco Hero 🌿';
    if (points >= 100) return 'Green Advocate 🌱';
    return 'Eco Beginner 🍃';
  }

  Widget _buildBadgeChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentUserModelProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User profile not available'));
          }

          final imageProvider = AppImageHelper.getImageProvider(user.photoUrl);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar & User Info
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.primaryContainer,
                        backgroundImage: imageProvider,
                        child: imageProvider == null
                            ? Text(
                                user.displayName.isNotEmpty
                                    ? user.displayName[0].toUpperCase()
                                    : 'E',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Name & Email
                      Text(
                        user.displayName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            user.location.city,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (user.bio != null && user.bio!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.bio!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Eco Badges Gallery
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildBadgeChip('Zero Waste ♻️', Icons.recycling_rounded, AppColors.primary),
                          _buildBadgeChip('Carbon Champion 🏆', Icons.emoji_events_rounded, AppColors.tertiary),
                          _buildBadgeChip('Local Swapper 🌟', Icons.swap_horizontal_circle_rounded, AppColors.secondary),
                          _buildBadgeChip('Fast Responder ⚡', Icons.bolt_rounded, AppColors.paidType),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Impact Stats Grid
                      Row(
                        children: [
                          // Eco Score Card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.eco_rounded, color: AppColors.primary, size: 28),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${user.ecoScore} pts',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getEcoLevel(user.ecoScore),
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // CO2 Saved Card (Clickable -> Carbon Dashboard)
                          Expanded(
                            child: InkWell(
                              onTap: () => context.push('/carbon-impact'),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.co2_rounded, color: AppColors.secondary, size: 32),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppFormatters.formatCo2(user.totalCo2Saved),
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Impact Analytics',
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: AppColors.secondaryDark,
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.secondaryDark),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Bar Header
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_view_rounded), text: 'My Listings'),
                      Tab(icon: Icon(Icons.settings_rounded), text: 'Settings'),
                    ],
                  ),
                  theme.scaffoldBackgroundColor,
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: My Listings
                const MyListingsTab(),

                // Tab 2: Settings & Preferences
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline_rounded),
                      title: const Text('Edit Profile'),
                      subtitle: const Text('Update display name, bio, and photo'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/profile/edit'),
                    ),
                    const Divider(),

                    // Dark / Light Theme Mode
                    SwitchListTile(
                      secondary: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                      ),
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Toggle app color scheme'),
                      value: themeMode == ThemeMode.dark,
                      onChanged: (isDark) {
                        ref.read(themeModeProvider.notifier).state =
                            isDark ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.notifications_none_rounded),
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Messages, listing alerts & challenge updates'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notifications are enabled')),
                        );
                      },
                    ),
                    const Divider(),

                    // Logout
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                      title: const Text(
                        'Log Out',
                        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirm Log Out'),
                            content: const Text('Are you sure you want to sign out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && mounted) {
                          ref.read(authControllerProvider.notifier).signOut();
                          context.go('/login');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class MyListingsTab extends ConsumerWidget {
  const MyListingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(userListingsStreamProvider);
    final theme = Theme.of(context);

    return listingsAsync.when(
      data: (listings) {
        if (listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textMutedLight),
                const SizedBox(height: 12),
                Text(
                  'No listings created yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'List unused items to give them a second life!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final item = listings[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppImageHelper.buildImageWidget(
                    item.images.isNotEmpty ? item.images.first : null,
                    width: 56,
                    height: 56,
                  ),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${item.category} • ${item.type} • ${item.status}'),
                trailing: Text(
                  '${item.carbonSavedEstimate.toStringAsFixed(1)} kg CO₂',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => context.push('/listing/${item.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate(this._tabBar, this.backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
