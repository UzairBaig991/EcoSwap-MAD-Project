import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String text;
  final DateTime createdAt;
  final List<String> readBy;
  final bool isOffer;
  final String? offerItemTitle;
  final String? offerItemImage;
  final String? offerStatus; // Pending, Accepted, Declined

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName,
    required this.text,
    required this.createdAt,
    this.readBy = const [],
    this.isOffer = false,
    this.offerItemTitle,
    this.offerItemImage,
    this.offerStatus,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      chatId: json['chatId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderName: json['senderName'] as String?,
      text: json['text'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      readBy: List<String>.from(json['readBy'] ?? []),
      isOffer: json['isOffer'] as bool? ?? false,
      offerItemTitle: json['offerItemTitle'] as String?,
      offerItemImage: json['offerItemImage'] as String?,
      offerStatus: json['offerStatus'] as String?,
    );
  }

  factory MessageModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc, String chatId) {
    final data = doc.data() ?? {};

    return MessageModel(
      id: doc.id,
      chatId: chatId,
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String?,
      text: data['text'] as String? ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
      readBy: List<String>.from(data['readBy'] ?? []),
      isOffer: data['isOffer'] as bool? ?? false,
      offerItemTitle: data['offerItemTitle'] as String?,
      offerItemImage: data['offerItemImage'] as String?,
      offerStatus: data['offerStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
        'readBy': readBy,
        'isOffer': isOffer,
        'offerItemTitle': offerItemTitle,
        'offerItemImage': offerItemImage,
        'offerStatus': offerStatus,
      };

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'readBy': readBy,
      'isOffer': isOffer,
      'offerItemTitle': offerItemTitle,
      'offerItemImage': offerItemImage,
      'offerStatus': offerStatus,
    };
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? text,
    DateTime? createdAt,
    List<String>? readBy,
    bool? isOffer,
    String? offerItemTitle,
    String? offerItemImage,
    String? offerStatus,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      readBy: readBy ?? this.readBy,
      isOffer: isOffer ?? this.isOffer,
      offerItemTitle: offerItemTitle ?? this.offerItemTitle,
      offerItemImage: offerItemImage ?? this.offerItemImage,
      offerStatus: offerStatus ?? this.offerStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        senderName,
        text,
        createdAt,
        readBy,
        isOffer,
        offerItemTitle,
        offerItemImage,
        offerStatus,
      ];
}
