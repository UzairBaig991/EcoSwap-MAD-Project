import 'dart:io';
import '../models/listing_model.dart';

abstract class ListingRepository {
  Future<String> createListing(ListingModel listing, List<File> imageFiles);
  Future<void> updateListing(ListingModel listing, List<File> newImageFiles);
  Future<void> deleteListing(String listingId);
  Future<void> updateListingStatus(String listingId, String status, {String? claimedByUserId});
  Future<ListingModel?> getListingById(String listingId);
  Stream<List<ListingModel>> getNearbyListings({
    required double lat,
    required double lng,
    required double radiusKm,
    String? category,
    String? type,
    String? condition,
    String? searchQuery,
  });
}
