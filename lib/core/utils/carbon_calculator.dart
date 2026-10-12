class CarbonCalculator {
  CarbonCalculator._();

  // Category emission factors (kg CO2e avoided per reused item)
  static const Map<String, double> categoryFactors = {
    'Electronics': 25.0,
    'Clothing': 8.0,
    'Furniture': 45.0,
    'Food': 2.5,
    'Books': 3.0,
    'Services': 5.0,
    'Other': 10.0,
  };

  static double estimateCategorySavings(String category) {
    return categoryFactors[category] ?? 10.0;
  }

  // Equivalent tree absorption (~21 kg CO2 absorbed per tree per year)
  static double calculateTreeEquivalent(double co2Kg) {
    return co2Kg / 21.0;
  }

  // Equivalent gasoline passenger car driving distance (~0.21 kg CO2 per km)
  static double calculateCarKmAvoided(double co2Kg) {
    return co2Kg / 0.21;
  }

  // Equivalent smartphone charges (~0.008 kg CO2 per full charge)
  static int calculateSmartphoneCharges(double co2Kg) {
    return (co2Kg / 0.008).round();
  }

  static String getEquivalenceSummary(double co2Kg) {
    final trees = calculateTreeEquivalent(co2Kg).toStringAsFixed(1);
    final carKm = calculateCarKmAvoided(co2Kg).toStringAsFixed(0);
    return '🌲 Equivalent to $trees trees planted for a year or 🚗 avoiding $carKm km of car driving!';
  }
}
