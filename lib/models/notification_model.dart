import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String
  type; // 'pickup_request', 'donation_claimed', 'pickup_scheduled', 'donation_accepted', 'review_received'
  final String? relatedId; // donation id, pickup id, etc
  final bool isRead;
  final DateTime? createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    required this.isRead,
    this.createdAt,
    this.data,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: data['type'] ?? 'pickup_request',
      relatedId: data['relatedId'],
      isRead: data['isRead'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      data: data['data'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'relatedId': relatedId,
      'isRead': isRead,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'data': data ?? {},
    };
  }
}
