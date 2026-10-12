import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserLocation extends Equatable {
  final double lat;
  final double lng;
  final String city;
  final String geohash;

  const UserLocation({
    required this.lat,
    required this.lng,
    required this.city,
    required this.geohash,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      city: json['city'] as String? ?? 'Unknown',
      geohash: json['geohash'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'city': city,
        'geohash': geohash,
      };

  UserLocation copyWith({
    double? lat,
    double? lng,
    String? city,
    String? geohash,
  }) {
    return UserLocation(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      geohash: geohash ?? this.geohash,
    );
  }

  @override
  List<Object?> get props => [lat, lng, city, geohash];
}

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? bio;
  final UserLocation location;
  final int ecoScore;
  final double totalCo2Saved;
  final List<String> fcmTokens;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.bio,
    required this.location,
    this.ecoScore = 0,
    this.totalCo2Saved = 0.0,
    this.fcmTokens = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'EcoSwapper',
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      location: UserLocation.fromJson(json['location'] as Map<String, dynamic>? ?? {}),
      ecoScore: (json['ecoScore'] as num?)?.toInt() ?? 0,
      totalCo2Saved: (json['totalCo2Saved'] as num?)?.toDouble() ?? 0.0,
      fcmTokens: List<String>.from(json['fcmTokens'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final locMap = data['location'] as Map<String, dynamic>? ?? {};

    return UserModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'EcoSwapper',
      photoUrl: data['photoUrl'] as String?,
      bio: data['bio'] as String?,
      location: UserLocation(
        lat: (locMap['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (locMap['lng'] as num?)?.toDouble() ?? 0.0,
        city: locMap['city'] as String? ?? 'Unknown',
        geohash: locMap['geohash'] as String? ?? '',
      ),
      ecoScore: (data['ecoScore'] as num?)?.toInt() ?? 0,
      totalCo2Saved: (data['totalCo2Saved'] as num?)?.toDouble() ?? 0.0,
      fcmTokens: List<String>.from(data['fcmTokens'] ?? []),
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: (data['updatedAt'] is Timestamp)
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'bio': bio,
        'location': location.toJson(),
        'ecoScore': ecoScore,
        'totalCo2Saved': totalCo2Saved,
        'fcmTokens': fcmTokens,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'location': location.toJson(),
      'ecoScore': ecoScore,
      'totalCo2Saved': totalCo2Saved,
      'fcmTokens': fcmTokens,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? bio,
    UserLocation? location,
    int? ecoScore,
    double? totalCo2Saved,
    List<String>? fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      ecoScore: ecoScore ?? this.ecoScore,
      totalCo2Saved: totalCo2Saved ?? this.totalCo2Saved,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        bio,
        location,
        ecoScore,
        totalCo2Saved,
        fcmTokens,
        createdAt,
        updatedAt,
      ];
}
