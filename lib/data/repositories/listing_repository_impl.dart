import 'dart:io';
import '../datasources/listing_remote_datasource.dart';
import '../models/listing_model.dart';
import 'listing_repository.dart';

class ListingRepositoryImpl implements ListingRepository {
  final ListingRemoteDataSource _remoteDataSource;

  ListingRepositoryImpl({ListingRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ListingRemoteDataSourceImpl();

  @override
  Future<String> createListing(ListingModel listing, List<File> imageFiles) async {
    return await _remoteDataSource.createListing(listing, imageFiles);
  }

  @override
  Future<void> updateListing(ListingModel listing, List<File> newImageFiles) async {
    await _remoteDataSource.updateListing(listing, newImageFiles);
  }

  @override
  Future<void> deleteListing(String listingId) async {
    await _remoteDataSource.deleteListing(listingId);
  }

  @override
  Future<void> updateListingStatus(String listingId, String status, {String? claimedByUserId}) async {
    await _remoteDataSource.updateListingStatus(listingId, status, claimedByUserId: claimedByUserId);
  }

  @override
  Future<ListingModel?> getListingById(String listingId) async {
    return await _remoteDataSource.getListingById(listingId);
  }

  @override
  Stream<List<ListingModel>> getNearbyListings({
    required double lat,
    required double lng,
    required double radiusKm,
    String? category,
    String? type,
    String? condition,
    String? searchQuery,
  }) {
    return _remoteDataSource.getNearbyListings(
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
      category: category,
      type: type,
      condition: condition,
      searchQuery: searchQuery,
    );
  }
}
