import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FavoriteModel extends Equatable {
  final String listingId;
  final DateTime addedAt;

  const FavoriteModel({
    required this.listingId,
    required this.addedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      listingId: json['listingId'] as String? ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'].toString())
          : DateTime.now(),
    );
  }

  factory FavoriteModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return FavoriteModel(
      listingId: doc.id,
      addedAt: (data['addedAt'] is Timestamp)
          ? (data['addedAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['addedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'listingId': listingId,
        'addedAt': addedAt.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() {
    return {
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  @override
  List<Object?> get props => [listingId, addedAt];
}
