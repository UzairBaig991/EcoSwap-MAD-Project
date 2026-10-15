import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/listing_model.dart';
import '../../core/constants/app_constants.dart';

abstract class FavoritesLocalDataSource {
  Future<void> saveFavorite(ListingModel listing);
  Future<void> removeFavorite(String listingId);
  List<ListingModel> getCachedFavorites();
  bool isFavorite(String listingId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  Box? _box;

  Future<Box> _getBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox(AppConstants.favoritesBox);
    return _box!;
  }

  @override
  Future<void> saveFavorite(ListingModel listing) async {
    final box = await _getBox();
    await box.put(listing.id, jsonEncode(listing.toJson()));
  }

  @override
  Future<void> removeFavorite(String listingId) async {
    final box = await _getBox();
    await box.delete(listingId);
  }

  @override
  List<ListingModel> getCachedFavorites() {
    if (_box == null || !_box!.isOpen) return [];
    final List<ListingModel> items = [];
    for (final key in _box!.keys) {
      try {
        final jsonString = _box!.get(key) as String?;
        if (jsonString != null) {
          items.add(ListingModel.fromJson(jsonDecode(jsonString)));
        }
      } catch (_) {}
    }
    return items;
  }

  @override
  bool isFavorite(String listingId) {
    if (_box == null || !_box!.isOpen) return false;
    return _box!.containsKey(listingId);
  }
}
