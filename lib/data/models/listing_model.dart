import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ListingLocation extends Equatable {
  final double lat;
  final double lng;
  final String geohash;
  final String address;

  const ListingLocation({
    required this.lat,
    required this.lng,
    required this.geohash,
    required this.address,
  });

  factory ListingLocation.fromJson(Map<String, dynamic> json) {
    return ListingLocation(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      geohash: json['geohash'] as String? ?? '',
      address: json['address'] as String? ?? 'Nearby',
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'geohash': geohash,
        'address': address,
      };

  ListingLocation copyWith({
    double? lat,
    double? lng,
    String? geohash,
    String? address,
  }) {
    return ListingLocation(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      geohash: geohash ?? this.geohash,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [lat, lng, geohash, address];
}

class ListingModel extends Equatable {
  final String id;
  final String ownerId;
  final String ownerName;
  final String? ownerPhotoUrl;
  final String title;
  final String description;
  final String category;
  final String condition;
  final String type; // Free, Swap, Paid
  final double? price;
  final List<String> images;
  final ListingLocation location;
  final String status; // Active, Claimed, Completed, Deleted
  final String? claimedByUserId;
  final double carbonSavedEstimate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;
  final int viewCount;
  final int favoriteCount;

  const ListingModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    this.ownerPhotoUrl,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    required this.type,
    this.price,
    required this.images,
    required this.location,
    this.status = 'Active',
    this.claimedByUserId,
    this.carbonSavedEstimate = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
    this.viewCount = 0,
    this.favoriteCount = 0,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? 'Anonymous',
      ownerPhotoUrl: json['ownerPhotoUrl'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Other',
      condition: json['condition'] as String? ?? 'Good',
      type: json['type'] as String? ?? 'Free',
      price: (json['price'] as num?)?.toDouble(),
      images: List<String>.from(json['images'] ?? []),
      location: ListingLocation.fromJson(json['location'] as Map<String, dynamic>? ?? {}),
      status: json['status'] as String? ?? 'Active',
      claimedByUserId: json['claimedByUserId'] as String?,
      carbonSavedEstimate: (json['carbonSavedEstimate'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'].toString())
          : null,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
    );
  }

  factory ListingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final locMap = data['location'] as Map<String, dynamic>? ?? {};

    return ListingModel(
      id: doc.id,
      ownerId: data['ownerId'] as String? ?? '',
      ownerName: data['ownerName'] as String? ?? 'Anonymous',
      ownerPhotoUrl: data['ownerPhotoUrl'] as String?,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'Other',
      condition: data['condition'] as String? ?? 'Good',
      type: data['type'] as String? ?? 'Free',
      price: (data['price'] as num?)?.toDouble(),
      images: List<String>.from(data['images'] ?? []),
      location: ListingLocation(
        lat: (locMap['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (locMap['lng'] as num?)?.toDouble() ?? 0.0,
        geohash: locMap['geohash'] as String? ?? '',
        address: locMap['address'] as String? ?? 'Nearby',
      ),
      status: data['status'] as String? ?? 'Active',
      claimedByUserId: data['claimedByUserId'] as String?,
      carbonSavedEstimate: (data['carbonSavedEstimate'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: (data['updatedAt'] is Timestamp)
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      expiresAt: (data['expiresAt'] is Timestamp)
          ? (data['expiresAt'] as Timestamp).toDate()
          : null,
      viewCount: (data['viewCount'] as num?)?.toInt() ?? 0,
      favoriteCount: (data['favoriteCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'ownerPhotoUrl': ownerPhotoUrl,
        'title': title,
        'description': description,
        'category': category,
        'condition': condition,
        'type': type,
        'price': price,
        'images': images,
        'location': location.toJson(),
        'status': status,
        'claimedByUserId': claimedByUserId,
        'carbonSavedEstimate': carbonSavedEstimate,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'viewCount': viewCount,
        'favoriteCount': favoriteCount,
      };

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhotoUrl': ownerPhotoUrl,
      'title': title,
      'description': description,
      'category': category,
      'condition': condition,
      'type': type,
      'price': price,
      'images': images,
      'location': location.toJson(),
      'status': status,
      'claimedByUserId': claimedByUserId,
      'carbonSavedEstimate': carbonSavedEstimate,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'viewCount': viewCount,
      'favoriteCount': favoriteCount,
    };
  }

  ListingModel copyWith({
    String? id,
    String? ownerId,
    String? ownerName,
    String? ownerPhotoUrl,
    String? title,
    String? description,
    String? category,
    String? condition,
    String? type,
    double? price,
    List<String>? images,
    ListingLocation? location,
    String? status,
    String? claimedByUserId,
    double? carbonSavedEstimate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
    int? viewCount,
    int? favoriteCount,
  }) {
    return ListingModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhotoUrl: ownerPhotoUrl ?? this.ownerPhotoUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      type: type ?? this.type,
      price: price ?? this.price,
      images: images ?? this.images,
      location: location ?? this.location,
      status: status ?? this.status,
      claimedByUserId: claimedByUserId ?? this.claimedByUserId,
      carbonSavedEstimate: carbonSavedEstimate ?? this.carbonSavedEstimate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      viewCount: viewCount ?? this.viewCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        ownerName,
        ownerPhotoUrl,
        title,
        description,
        category,
        condition,
        type,
        price,
        images,
        location,
        status,
        claimedByUserId,
        carbonSavedEstimate,
        createdAt,
        updatedAt,
        expiresAt,
        viewCount,
        favoriteCount,
      ];
}
