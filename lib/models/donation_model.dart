import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String id;
  final String donorId;
  final String category;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String condition; // 'new', 'like-new', 'good', 'fair'
  final String status; // 'available', 'claimed', 'picked-up', 'delivered'
  final double? latitude;
  final double? longitude;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? claimedBy;
  final String? priority; // 'low', 'medium', 'high'
  final bool? isUrgent;
  final int? views;
  final int? claims;

  DonationModel({
    required this.id,
    required this.donorId,
    required this.category,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.condition,
    required this.status,
    this.latitude,
    this.longitude,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.claimedBy,
    this.priority,
    this.isUrgent,
    this.views,
    this.claims,
  });

  factory DonationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DonationModel(
      id: doc.id,
      donorId: data['donorId'] ?? '',
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      condition: data['condition'] ?? 'good',
      status: data['status'] ?? 'available',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      location: data['location'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      claimedBy: data['claimedBy'],
      priority: data['priority'] ?? 'medium',
      isUrgent: data['isUrgent'] ?? false,
      views: data['views'] ?? 0,
      claims: data['claims'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'donorId': donorId,
      'category': category,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'condition': condition,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': DateTime.now(),
      'claimedBy': claimedBy,
      'priority': priority ?? 'medium',
      'isUrgent': isUrgent ?? false,
      'views': views ?? 0,
      'claims': claims ?? 0,
    };
  }
}
