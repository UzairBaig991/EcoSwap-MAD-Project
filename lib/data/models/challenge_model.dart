import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChallengeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String targetType; // listings, exchanges, co2_saved
  final double targetValue;
  final int rewardPoints;
  final String? iconName;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.targetType,
    required this.targetValue,
    this.rewardPoints = 100,
    this.iconName,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'].toString())
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'].toString())
          : DateTime.now().add(const Duration(days: 7)),
      targetType: json['targetType'] as String? ?? 'listings',
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 3.0,
      rewardPoints: (json['rewardPoints'] as num?)?.toInt() ?? 100,
      iconName: json['iconName'] as String?,
    );
  }

  factory ChallengeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return ChallengeModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      startDate: (data['startDate'] is Timestamp)
          ? (data['startDate'] as Timestamp).toDate()
          : DateTime.tryParse(data['startDate']?.toString() ?? '') ?? DateTime.now(),
      endDate: (data['endDate'] is Timestamp)
          ? (data['endDate'] as Timestamp).toDate()
          : DateTime.tryParse(data['endDate']?.toString() ?? '') ?? DateTime.now().add(const Duration(days: 7)),
      targetType: data['targetType'] as String? ?? 'listings',
      targetValue: (data['targetValue'] as num?)?.toDouble() ?? 3.0,
      rewardPoints: (data['rewardPoints'] as num?)?.toInt() ?? 100,
      iconName: data['iconName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'targetType': targetType,
        'targetValue': targetValue,
        'rewardPoints': rewardPoints,
        'iconName': iconName,
      };

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'targetType': targetType,
      'targetValue': targetValue,
      'rewardPoints': rewardPoints,
      'iconName': iconName,
    };
  }

  ChallengeModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? targetType,
    double? targetValue,
    int? rewardPoints,
    String? iconName,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      iconName: iconName ?? this.iconName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startDate,
        endDate,
        targetType,
        targetValue,
        rewardPoints,
        iconName,
      ];
}
