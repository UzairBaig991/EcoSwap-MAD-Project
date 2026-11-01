class TrustReliabilityProfile {
  final String userId;
  final double trustScore; // 0.0 to 100.0
  final int completedSwaps;
  final double onTimeRate; // percentage
  final double cancellationRate; // percentage
  final bool isIdentityVerified;
  final int totalReviews;

  const TrustReliabilityProfile({
    required this.userId,
    required this.trustScore,
    required this.completedSwaps,
    required this.onTimeRate,
    required this.cancellationRate,
    required this.isIdentityVerified,
    required this.totalReviews,
  });
}

class ItemJourneyRecord {
  final String itemId;
  final String eventDescription;
  final DateTime timestamp;
  final String conditionAtTime;

  const ItemJourneyRecord({
    required this.itemId,
    required this.eventDescription,
    required this.timestamp,
    required this.conditionAtTime,
  });
}

class TrustReliabilityService {
  static TrustReliabilityProfile getMockProfile(String userId) {
    return TrustReliabilityProfile(
      userId: userId,
      trustScore: 96.5,
      completedSwaps: 24,
      onTimeRate: 98.0,
      cancellationRate: 1.5,
      isIdentityVerified: true,
      totalReviews: 22,
    );
  }

  static List<ItemJourneyRecord> getItemJourney(String itemId) {
    return [
      ItemJourneyRecord(
        itemId: itemId,
        eventDescription: 'Listed on EcoSwap by original owner',
        timestamp: DateTime.now().subtract(const Duration(days: 30)),
        conditionAtTime: 'Like New',
      ),
      ItemJourneyRecord(
        itemId: itemId,
        eventDescription: 'Successfully swapped in community zero-waste event',
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        conditionAtTime: 'Good',
      ),
    ];
  }
}
