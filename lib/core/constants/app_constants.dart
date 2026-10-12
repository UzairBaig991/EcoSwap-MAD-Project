class AppConstants {
  AppConstants._();

  static const String appName = 'EcoSwap';
  static const String appTagline = 'Swap items, save money, help the planet';

  // Map & Location
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const double defaultRadiusKm = 10.0;
  static const List<double> radiusOptions = [5.0, 10.0, 25.0, 50.0];

  // Listing Categories
  static const List<String> categories = [
    'Electronics',
    'Clothing',
    'Furniture',
    'Food',
    'Books',
    'Services',
    'Other',
  ];

  // Listing Conditions
  static const List<String> conditions = [
    'New',
    'Like New',
    'Good',
    'Fair',
  ];

  // Listing Types
  static const List<String> listingTypes = [
    'Free',
    'Swap',
    'Paid',
  ];

  // CO2 Estimation reference values (in kg per item re-used)
  static const Map<String, double> co2SavedPerCategory = {
    'Electronics': 25.0,
    'Clothing': 8.0,
    'Furniture': 45.0,
    'Food': 2.5,
    'Books': 3.0,
    'Services': 5.0,
    'Other': 10.0,
  };

  // Points system
  static const int pointsPerListingCreated = 10;
  static const int pointsPerListingCompleted = 50;
  static const int pointsPerReviewGiven = 5;

  // Max image count for listings
  static const int maxListingImages = 5;
  static const int minListingImages = 1;

  // Hive Box Names
  static const String favoritesBox = 'favorites_box';
  static const String settingsBox = 'settings_box';
}
