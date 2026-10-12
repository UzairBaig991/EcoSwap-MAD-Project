import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserChallengeModel extends Equatable {
  final String id;
  final String userId;
  final String challengeId;
  final double progress;
  final bool completed;
  final DateTime? completedAt;

  const UserChallengeModel({
    required this.id,
    required this.userId,
    required this.challengeId,
    this.progress = 0.0,
    this.completed = false,
    this.completedAt,
  });

  factory UserChallengeModel.fromJson(Map<String, dynamic> json) {
    return UserChallengeModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      challengeId: json['challengeId'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'].toString())
          : null,
    );
  }

  factory UserChallengeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return UserChallengeModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      challengeId: data['challengeId'] as String? ?? '',
      progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
      completed: data['completed'] as bool? ?? false,
      completedAt: (data['completedAt'] is Timestamp)
          ? (data['completedAt'] as Timestamp).toDate()
          : (data['completedAt'] != null)
              ? DateTime.tryParse(data['completedAt'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'challengeId': challengeId,
        'progress': progress,
        'completed': completed,
        'completedAt': completedAt?.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'challengeId': challengeId,
      'progress': progress,
      'completed': completed,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  UserChallengeModel copyWith({
    String? id,
    String? userId,
    String? challengeId,
    double? progress,
    bool? completed,
    DateTime? completedAt,
  }) {
    return UserChallengeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      challengeId: challengeId ?? this.challengeId,
      progress: progress ?? this.progress,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        challengeId,
        progress,
        completed,
        completedAt,
      ];
}
