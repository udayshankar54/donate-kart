import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? phone;
  final String name;
  final String? profileImageUrl;
  final String userType; // 'donor', 'volunteer', 'ngo'
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? rating;
  final int? reviewCount;
  final bool? isVerified;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.uid,
    required this.email,
    this.phone,
    required this.name,
    this.profileImageUrl,
    required this.userType,
    this.latitude,
    this.longitude,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.rating,
    this.reviewCount,
    this.isVerified,
    this.metadata,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      phone: data['phone'],
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      userType: data['userType'] ?? 'donor',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      address: data['address'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      rating: data['rating']?.toDouble(),
      reviewCount: data['reviewCount'],
      isVerified: data['isVerified'] ?? false,
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'phone': phone,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'userType': userType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': DateTime.now(),
      'rating': rating ?? 0.0,
      'reviewCount': reviewCount ?? 0,
      'isVerified': isVerified ?? false,
      'metadata': metadata ?? {},
    };
  }
}
