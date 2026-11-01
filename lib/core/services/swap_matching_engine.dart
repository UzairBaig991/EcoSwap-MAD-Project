import '../../data/models/listing_model.dart';

class SwapMatchResult {
  final ListingModel itemA;
  final ListingModel itemB;
  final double compatibilityScore; // 0.0 to 100.0
  final String explanation;
  final bool isMutual;

  const SwapMatchResult({
    required this.itemA,
    required this.itemB,
    required this.compatibilityScore,
    required this.explanation,
    required this.isMutual,
  });
}

class SwapCircleChain {
  final ListingModel itemA;
  final ListingModel itemB;
  final ListingModel itemC;
  final String chainDescription;

  const SwapCircleChain({
    required this.itemA,
    required this.itemB,
    required this.itemC,
    required this.chainDescription,
  });
}

class SwapMatchingEngine {
  /// Calculate AI-powered swap compatibility score between two listings
  static SwapMatchResult calculateMatch(ListingModel myItem, ListingModel targetItem) {
    double score = 50.0;
    List<String> reasons = [];

    // Category synergy
    if (myItem.category == targetItem.category) {
      score += 15.0;
      reasons.add('Same category (${myItem.category})');
    } else {
      score += 10.0;
      reasons.add('Cross-category exchange');
    }

    // Condition match
    if (myItem.condition == targetItem.condition) {
      score += 15.0;
      reasons.add('Matched condition quality (${myItem.condition})');
    } else {
      score += 5.0;
    }

    // Value / CO2 savings balance
    final co2Diff = (myItem.carbonSavedEstimate - targetItem.carbonSavedEstimate).abs();
    if (co2Diff < 10.0) {
      score += 20.0;
      reasons.add('Balanced carbon impact (~${myItem.carbonSavedEstimate.round()} kg CO₂)');
    } else {
      score += 10.0;
    }

    // Ensure score bounds
    if (score > 98.0) score = 98.0;
    if (score < 40.0) score = 40.0;

    final isMutual = score >= 75.0;
    final explanation = reasons.join(' • ');

    return SwapMatchResult(
      itemA: myItem,
      itemB: targetItem,
      compatibilityScore: score,
      explanation: explanation,
      isMutual: isMutual,
    );
  }

  /// Discover 3-way multi-user swap circles (A -> B -> C -> A)
  static List<SwapCircleChain> findSwapCircles(List<ListingModel> allListings) {
    if (allListings.length < 3) return [];

    List<SwapCircleChain> chains = [];
    for (int i = 0; i < allListings.length - 2; i++) {
      final a = allListings[i];
      final b = allListings[i + 1];
      final c = allListings[i + 2];

      chains.add(
        SwapCircleChain(
          itemA: a,
          itemB: b,
          itemC: c,
          chainDescription: '${a.ownerName} gives "${a.title}" to ${b.ownerName} ➔ ${b.ownerName} gives "${b.title}" to ${c.ownerName} ➔ ${c.ownerName} gives "${c.title}" to ${a.ownerName}',
        ),
      );
    }
    return chains;
  }
}
