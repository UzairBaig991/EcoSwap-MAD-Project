import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String id;
  final String listingId;
  final String listingTitle;
  final String? listingImage;
  final List<String> participants;
  final Map<String, String> participantNames;
  final Map<String, String> participantPhotos;
  final String lastMessage;
  final String lastMessageSenderId;
  final DateTime lastMessageAt;
  final Map<String, int> unreadCount;
  final DateTime createdAt;

  const ChatModel({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    this.listingImage,
    required this.participants,
    this.participantNames = const {},
    this.participantPhotos = const {},
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageAt,
    this.unreadCount = const {},
    required this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      listingTitle: json['listingTitle'] as String? ?? 'Listing Item',
      listingImage: json['listingImage'] as String?,
      participants: List<String>.from(json['participants'] ?? []),
      participantNames: Map<String, String>.from(json['participantNames'] ?? {}),
      participantPhotos: Map<String, String>.from(json['participantPhotos'] ?? {}),
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageSenderId: json['lastMessageSenderId'] as String? ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'].toString())
          : DateTime.now(),
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  factory ChatModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return ChatModel(
      id: doc.id,
      listingId: data['listingId'] as String? ?? '',
      listingTitle: data['listingTitle'] as String? ?? 'Listing Item',
      listingImage: data['listingImage'] as String?,
      participants: List<String>.from(data['participants'] ?? []),
      participantNames: Map<String, String>.from(data['participantNames'] ?? {}),
      participantPhotos: Map<String, String>.from(data['participantPhotos'] ?? {}),
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageSenderId: data['lastMessageSenderId'] as String? ?? '',
      lastMessageAt: (data['lastMessageAt'] is Timestamp)
          ? (data['lastMessageAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['lastMessageAt']?.toString() ?? '') ?? DateTime.now(),
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'listingId': listingId,
        'listingTitle': listingTitle,
        'listingImage': listingImage,
        'participants': participants,
        'participantNames': participantNames,
        'participantPhotos': participantPhotos,
        'lastMessage': lastMessage,
        'lastMessageSenderId': lastMessageSenderId,
        'lastMessageAt': lastMessageAt.toIso8601String(),
        'unreadCount': unreadCount,
        'createdAt': createdAt.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() {
    return {
      'listingId': listingId,
      'listingTitle': listingTitle,
      'listingImage': listingImage,
      'participants': participants,
      'participantNames': participantNames,
      'participantPhotos': participantPhotos,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
      'unreadCount': unreadCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ChatModel copyWith({
    String? id,
    String? listingId,
    String? listingTitle,
    String? listingImage,
    List<String>? participants,
    Map<String, String>? participantNames,
    Map<String, String>? participantPhotos,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    Map<String, int>? unreadCount,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      listingTitle: listingTitle ?? this.listingTitle,
      listingImage: listingImage ?? this.listingImage,
      participants: participants ?? this.participants,
      participantNames: participantNames ?? this.participantNames,
      participantPhotos: participantPhotos ?? this.participantPhotos,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listingId,
        listingTitle,
        listingImage,
        participants,
        participantNames,
        participantPhotos,
        lastMessage,
        lastMessageSenderId,
        lastMessageAt,
        unreadCount,
        createdAt,
      ];
}
