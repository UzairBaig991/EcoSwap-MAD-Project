import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../home/providers/home_provider.dart';
import '../../home/widgets/listing_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final offlineFavorites = ref.watch(offlineFavoritesProvider);
    final favoriteIds = ref.watch(favoritesControllerProvider);
    final filter = ref.watch(homeFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
      ),
      body: offlineFavorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    size: 64,
                    color: AppColors.textMutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.emptyFavorites,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the heart icon on any listing to save it for offline access.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offlineFavorites.length,
              itemBuilder: (context, index) {
                final item = offlineFavorites[index];
                return ListingCard(
                  listing: item,
                  userLat: filter.userLat,
                  userLng: filter.userLng,
                  isFavorited: favoriteIds.contains(item.id),
                  onFavoriteToggle: () {
                    ref.read(favoritesControllerProvider.notifier).toggleFavorite(item);
                  },
                );
              },
            ),
    );
  }
}
