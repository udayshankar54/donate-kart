import 'package:cloud_firestore/cloud_firestore.dart';

class PickupModel {
  final String id;
  final String donationId;
  final String donorId;
  final String volunteerId;
  final String status; // 'scheduled', 'in-progress', 'completed', 'cancelled'
  final DateTime? scheduledTime;
  final DateTime? completedTime;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? pickupAddress;
  final double? dropLatitude;
  final double? dropLongitude;
  final String? dropAddress;
  final String? notes;
  final List<String> proofImageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? ngoId;
  final double? distance;
  final String? rating;

  PickupModel({
    required this.id,
    required this.donationId,
    required this.donorId,
    required this.volunteerId,
    required this.status,
    this.scheduledTime,
    this.completedTime,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupAddress,
    this.dropLatitude,
    this.dropLongitude,
    this.dropAddress,
    this.notes,
    required this.proofImageUrls,
    this.createdAt,
    this.updatedAt,
    this.ngoId,
    this.distance,
    this.rating,
  });

  factory PickupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PickupModel(
      id: doc.id,
      donationId: data['donationId'] ?? '',
      donorId: data['donorId'] ?? '',
      volunteerId: data['volunteerId'] ?? '',
      status: data['status'] ?? 'scheduled',
      scheduledTime: data['scheduledTime'] != null
          ? (data['scheduledTime'] as Timestamp).toDate()
          : null,
      completedTime: data['completedTime'] != null
          ? (data['completedTime'] as Timestamp).toDate()
          : null,
      pickupLatitude: data['pickupLatitude']?.toDouble(),
      pickupLongitude: data['pickupLongitude']?.toDouble(),
      pickupAddress: data['pickupAddress'],
      dropLatitude: data['dropLatitude']?.toDouble(),
      dropLongitude: data['dropLongitude']?.toDouble(),
      dropAddress: data['dropAddress'],
      notes: data['notes'],
      proofImageUrls: List<String>.from(data['proofImageUrls'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      ngoId: data['ngoId'],
      distance: data['distance']?.toDouble(),
      rating: data['rating'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'donationId': donationId,
      'donorId': donorId,
      'volunteerId': volunteerId,
      'status': status,
      'scheduledTime': scheduledTime,
      'completedTime': completedTime,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'pickupAddress': pickupAddress,
      'dropLatitude': dropLatitude,
      'dropLongitude': dropLongitude,
      'dropAddress': dropAddress,
      'notes': notes,
      'proofImageUrls': proofImageUrls,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': DateTime.now(),
      'ngoId': ngoId,
      'distance': distance,
      'rating': rating,
    };
  }
}
