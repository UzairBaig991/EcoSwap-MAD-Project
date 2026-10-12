import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String listingId;
  final String fromUserId;
  final String? fromUserName;
  final String? fromUserPhoto;
  final String toUserId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.listingId,
    required this.fromUserId,
    this.fromUserName,
    this.fromUserPhoto,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      fromUserId: json['fromUserId'] as String? ?? '',
      fromUserName: json['fromUserName'] as String?,
      fromUserPhoto: json['fromUserPhoto'] as String?,
      toUserId: json['toUserId'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  factory ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return ReviewModel(
      id: doc.id,
      listingId: data['listingId'] as String? ?? '',
      fromUserId: data['fromUserId'] as String? ?? '',
      fromUserName: data['fromUserName'] as String?,
      fromUserPhoto: data['fromUserPhoto'] as String?,
      toUserId: data['toUserId'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      comment: data['comment'] as String? ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'listingId': listingId,
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'fromUserPhoto': fromUserPhoto,
        'toUserId': toUserId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() {
    return {
      'listingId': listingId,
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'fromUserPhoto': fromUserPhoto,
      'toUserId': toUserId,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ReviewModel copyWith({
    String? id,
    String? listingId,
    String? fromUserId,
    String? fromUserName,
    String? fromUserPhoto,
    String? toUserId,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUserName: fromUserName ?? this.fromUserName,
      fromUserPhoto: fromUserPhoto ?? this.fromUserPhoto,
      toUserId: toUserId ?? this.toUserId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listingId,
        fromUserId,
        fromUserName,
        fromUserPhoto,
        toUserId,
        rating,
        comment,
        createdAt,
      ];
}
