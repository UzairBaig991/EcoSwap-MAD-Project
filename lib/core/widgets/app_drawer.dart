import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../utils/app_image_helper.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../main.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Drawer(
      child: Column(
        children: [
          // Drawer Header with User Avatar & Eco Score
          userAsync.when(
            data: (user) {
              final imageProvider = AppImageHelper.getImageProvider(user?.photoUrl);

              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: AppColors.ecoGradient,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          (user?.displayName.isNotEmpty == true)
                              ? user!.displayName[0].toUpperCase()
                              : 'E',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                accountName: Text(
                  user?.displayName ?? 'Eco Swapper',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                accountEmail: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '🌿 ${user?.ecoScore ?? 0} Eco Points',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => Container(
              height: 180,
              color: AppColors.primary,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
            error: (_, __) => Container(
              height: 180,
              color: AppColors.primary,
              child: const Center(child: Text('EcoSwap', style: TextStyle(color: Colors.white, fontSize: 20))),
            ),
          ),

          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.explore_rounded, color: AppColors.primary),
                  title: const Text('Explore Marketplace'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
                  title: const Text('Messages & Swap Chats'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/chats');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle_rounded, color: AppColors.primary),
                  title: const Text('Post New Item'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/create-listing');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: AppColors.error),
                  title: const Text('Saved Favorites'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/favorites');
                  },
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(Icons.co2_rounded, color: AppColors.secondary),
                  title: const Text('Carbon Footprint Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-impact');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events_rounded, color: AppColors.tertiary),
                  title: const Text('Eco Challenges & Leaderboard'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/challenges');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_rounded, color: AppColors.primary),
                  title: const Text('My Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_rounded, color: AppColors.primary),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                const Divider(),

                // Dark Mode Switch
                SwitchListTile(
                  secondary: Icon(
                    themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Dark Theme'),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (isDark) {
                    ref.read(themeModeProvider.notifier).state =
                        isDark ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ],
            ),
          ),

          // Logout Footer
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
