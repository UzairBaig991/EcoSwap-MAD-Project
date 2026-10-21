import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../data/models/listing_model.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/listing_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final filter = ref.watch(homeFilterProvider);
            final notifier = ref.read(homeFilterProvider.notifier);

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Advanced Filters & Sorting',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          notifier.resetFilters();
                          _searchController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Sort By Selection
                  const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ListingSortOption>(
                    initialValue: filter.sortBy,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.sort_rounded)),
                    items: const [
                      DropdownMenuItem(
                        value: ListingSortOption.nearestFirst,
                        child: Text('Nearest First 📍'),
                      ),
                      DropdownMenuItem(
                        value: ListingSortOption.highestCo2,
                        child: Text('Highest CO₂ Saved 🌿'),
                      ),
                      DropdownMenuItem(
                        value: ListingSortOption.recentlyAdded,
                        child: Text('Recently Added ⏱️'),
                      ),
                      DropdownMenuItem(
                        value: ListingSortOption.priceLowToHigh,
                        child: Text('Price: Low to High 💵'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) notifier.setSortBy(val);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Radius Filter
                  Text(
                    'Search Radius (${filter.radiusKm.round()} km)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<double>(
                    segments: AppConstants.radiusOptions.map((r) {
                      return ButtonSegment(value: r, label: Text('${r.round()} km'));
                    }).toList(),
                    selected: {filter.radiusKm},
                    onSelectionChanged: (set) => notifier.setRadius(set.first),
                  ),
                  const SizedBox(height: 20),

                  // Listing Type
                  const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', ...AppConstants.listingTypes].map((t) {
                      return ChoiceChip(
                        label: Text(t),
                        selected: filter.selectedType == t,
                        onSelected: (selected) {
                          if (selected) notifier.setType(t);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Condition
                  const Text('Condition', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', ...AppConstants.conditions].map((c) {
                      return ChoiceChip(
                        label: Text(c),
                        selected: filter.selectedCondition == c,
                        onSelected: (selected) {
                          if (selected) notifier.setCondition(c);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showListingMapPreview(ListingModel listing) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final favoriteIds = ref.watch(favoritesControllerProvider);
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListingCard(
                listing: listing,
                userLat: ref.read(homeFilterProvider).userLat,
                userLng: ref.read(homeFilterProvider).userLng,
                isFavorited: favoriteIds.contains(listing.id),
                onFavoriteToggle: () {
                  ref.read(favoritesControllerProvider.notifier).toggleFavorite(listing);
                },
              ),
            );
          },
        );
      },
    );
  }

  Set<Marker> _buildMapMarkers(List<ListingModel> listings) {
    return listings.map((item) {
      BitmapDescriptor hue;
      if (item.type == 'Free') {
        hue = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else if (item.type == 'Swap') {
        hue = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      } else {
        hue = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      }

      return Marker(
        markerId: MarkerId(item.id),
        position: LatLng(item.location.lat, item.location.lng),
        icon: hue,
        infoWindow: InfoWindow(
          title: item.title,
          snippet: '${item.category} • ${item.location.address}',
        ),
        onTap: () => _showListingMapPreview(item),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filter = ref.watch(homeFilterProvider);
    final filterNotifier = ref.read(homeFilterProvider.notifier);
    final listingsAsync = ref.watch(nearbyListingsStreamProvider);
    final favoriteIds = ref.watch(favoritesControllerProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
            tooltip: 'Open Navigation Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.swap_horizontal_circle_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'EcoSwap',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filter & Sort',
            onPressed: _showFilterModal,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => filterNotifier.toggleViewMode(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.ecoGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filter.isMapView ? Icons.view_list_rounded : Icons.map_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filter.isMapView ? 'List' : 'Map',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Community Impact Live Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              gradient: AppColors.ecoGradient,
            ),
            child: Row(
              children: [
                const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Community Impact: 1,420 kg CO₂ saved together this month! 🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${filter.radiusKm.round()} km radius',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),

          // Search & Category Header
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => filterNotifier.setSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Search items, clothing, books...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              filterNotifier.setSearchQuery('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontal Category Selector Chips with Gradient Selection
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', ...AppConstants.categories].map((category) {
                      final isSelected = filter.selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => filterNotifier.setCategory(category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.ecoGradient : null,
                              color: isSelected ? null : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : theme.colorScheme.outline.withOpacity(0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main View (Map or List with AnimatedCrossFade)
          Expanded(
            child: listingsAsync.when(
              data: (listings) {
                final isMapView = filter.isMapView;

                Widget listViewWidget;
                if (listings.isEmpty) {
                  listViewWidget = Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 72,
                            color: AppColors.textMutedLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.emptyListings,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try expanding your search radius or clearing active filters.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () {
                              filterNotifier.resetFilters();
                              _searchController.clear();
                            },
                            child: const Text('Reset All Filters'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  listViewWidget = RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(nearbyListingsStreamProvider);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: listings.length,
                      itemBuilder: (context, index) {
                        final item = listings[index];
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

                Widget mapViewWidget;
                if (kIsWeb) {
                  mapViewWidget = Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Nearby Items (${listings.length} items within ${filter.radiusKm.round()} km)',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Showing location addresses and proximity-sorted listings:',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: listings.length,
                            itemBuilder: (context, idx) => ListingCard(
                              listing: listings[idx],
                              userLat: filter.userLat,
                              userLng: filter.userLng,
                              isFavorited: favoriteIds.contains(listings[idx].id),
                              onFavoriteToggle: () {
                                ref.read(favoritesControllerProvider.notifier).toggleFavorite(listings[idx]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  mapViewWidget = GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(filter.userLat, filter.userLng),
                      zoom: 12,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    markers: _buildMapMarkers(listings),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                  );
                }

                return AnimatedCrossFade(
                  firstChild: listViewWidget,
                  secondChild: mapViewWidget,
                  crossFadeState: isMapView ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                );
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 4,
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              error: (err, stack) => Center(
                child: Text('Error loading listings: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
