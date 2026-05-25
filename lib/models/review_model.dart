import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String comment;
  final String reviewType; // 'volunteer', 'ngo', 'donor'
  final String? relatedId; // pickup id or donation id
  final List<String> imageUrls;
  final DateTime? createdAt;
  final int? helpfulCount;
  final bool? isVerified;

  ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.comment,
    required this.reviewType,
    this.relatedId,
    required this.imageUrls,
    this.createdAt,
    this.helpfulCount,
    this.isVerified,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      reviewerId: data['reviewerId'] ?? '',
      revieweeId: data['revieweeId'] ?? '',
      rating: (data['rating'] ?? 5.0).toDouble(),
      comment: data['comment'] ?? '',
      reviewType: data['reviewType'] ?? 'volunteer',
      relatedId: data['relatedId'],
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      helpfulCount: data['helpfulCount'] ?? 0,
      isVerified: data['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'rating': rating,
      'comment': comment,
      'reviewType': reviewType,
      'relatedId': relatedId,
      'imageUrls': imageUrls,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'helpfulCount': helpfulCount ?? 0,
      'isVerified': isVerified ?? false,
    };
  }
}
