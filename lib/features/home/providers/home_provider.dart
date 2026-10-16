import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/listing_model.dart';
import '../../listing/providers/listing_provider.dart';

enum ListingSortOption { nearestFirst, highestCo2, priceLowToHigh, recentlyAdded }

class HomeFilterState {
  final String searchQuery;
  final String selectedCategory;
  final String selectedType;
  final String selectedCondition;
  final double radiusKm;
  final double userLat;
  final double userLng;
  final bool isMapView;
  final ListingSortOption sortBy;

  const HomeFilterState({
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.selectedType = 'All',
    this.selectedCondition = 'All',
    this.radiusKm = AppConstants.defaultRadiusKm,
    this.userLat = AppConstants.defaultLatitude,
    this.userLng = AppConstants.defaultLongitude,
    this.isMapView = false,
    this.sortBy = ListingSortOption.nearestFirst,
  });

  HomeFilterState copyWith({
    String? searchQuery,
    String? selectedCategory,
    String? selectedType,
    String? selectedCondition,
    double? radiusKm,
    double? userLat,
    double? userLng,
    bool? isMapView,
    ListingSortOption? sortBy,
  }) {
    return HomeFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedType: selectedType ?? this.selectedType,
      selectedCondition: selectedCondition ?? this.selectedCondition,
      radiusKm: radiusKm ?? this.radiusKm,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      isMapView: isMapView ?? this.isMapView,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class HomeFilterNotifier extends StateNotifier<HomeFilterState> {
  HomeFilterNotifier() : super(const HomeFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setType(String type) {
    state = state.copyWith(selectedType: type);
  }

  void setCondition(String condition) {
    state = state.copyWith(selectedCondition: condition);
  }

  void setRadius(double radiusKm) {
    state = state.copyWith(radiusKm: radiusKm);
  }

  void setSortBy(ListingSortOption option) {
    state = state.copyWith(sortBy: option);
  }

  void setUserLocation(double lat, double lng) {
    state = state.copyWith(userLat: lat, userLng: lng);
  }

  void toggleViewMode() {
    state = state.copyWith(isMapView: !state.isMapView);
  }

  void resetFilters() {
    state = HomeFilterState(
      userLat: state.userLat,
      userLng: state.userLng,
      isMapView: state.isMapView,
    );
  }
}

final homeFilterProvider =
    StateNotifierProvider<HomeFilterNotifier, HomeFilterState>((ref) {
  return HomeFilterNotifier();
});

// Haversine formula for distance calculation in KM
double calculateDistanceKm(
    double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295; // Math.PI / 180
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}

final nearbyListingsStreamProvider = StreamProvider<List<ListingModel>>((ref) {
  final filter = ref.watch(homeFilterProvider);
  final repo = ref.watch(listingRepositoryProvider);

  return repo
      .getNearbyListings(
    lat: filter.userLat,
    lng: filter.userLng,
    radiusKm: filter.radiusKm,
    category: filter.selectedCategory,
    type: filter.selectedType,
    condition: filter.selectedCondition,
    searchQuery: filter.searchQuery,
  )
      .map((listings) {
    // 1. Distance filter
    final filtered = listings.where((item) {
      final dist = calculateDistanceKm(
          filter.userLat, filter.userLng, item.location.lat, item.location.lng);
      return dist <= filter.radiusKm;
    }).toList();

    // 2. Advanced Sorting
    filtered.sort((a, b) {
      switch (filter.sortBy) {
        case ListingSortOption.highestCo2:
          return b.carbonSavedEstimate.compareTo(a.carbonSavedEstimate);
        case ListingSortOption.priceLowToHigh:
          final priceA = a.price ?? 0.0;
          final priceB = b.price ?? 0.0;
          return priceA.compareTo(priceB);
        case ListingSortOption.recentlyAdded:
          return b.createdAt.compareTo(a.createdAt);
        case ListingSortOption.nearestFirst:
        default:
          final distA = calculateDistanceKm(
              filter.userLat, filter.userLng, a.location.lat, a.location.lng);
          final distB = calculateDistanceKm(
              filter.userLat, filter.userLng, b.location.lat, b.location.lng);
          return distA.compareTo(distB);
      }
    });

    return filtered;
  });
});
