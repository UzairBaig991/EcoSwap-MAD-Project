import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../listing/screens/create_listing_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../favorites/screens/favorites_screen.dart';
import '../../challenges/screens/challenges_screen.dart';
import 'home_screen.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);

    final List<Widget> screens = const [
      HomeScreen(),
      FavoritesScreen(),
      CreateListingScreen(),
      ChallengesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        onDestinationSelected: (index) {
          ref.read(currentTabProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded, color: AppColors.primary),
            label: AppStrings.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline_rounded),
            selectedIcon: Icon(Icons.favorite_rounded, color: AppColors.primary),
            label: AppStrings.tabFavorites,
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded, size: 30),
            selectedIcon: Icon(Icons.add_circle_rounded, size: 30, color: AppColors.primary),
            label: AppStrings.tabCreate,
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events_rounded, color: AppColors.primary),
            label: AppStrings.tabChallenges,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: AppStrings.tabProfile,
          ),
        ],
      ),
    );
  }
}

class PlaceHolderTabScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceHolderTabScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      )),
    );
  }
}
