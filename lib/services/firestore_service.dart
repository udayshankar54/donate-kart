import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../models/donation_model.dart';
import '../models/pickup_model.dart';
import '../models/review_model.dart';
import '../models/notification_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // User Methods
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toFirestore());
      _logger.i('User created: ${user.uid}');
    } catch (e) {
      _logger.e('Create user error: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _logger.e('Get user error: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.i('User updated: $uid');
    } catch (e) {
      _logger.e('Update user error: $e');
      rethrow;
    }
  }

  // Donation Methods
  Future<String> createDonation(DonationModel donation) async {
    try {
      final docRef = await _firestore
          .collection('donations')
          .add(donation.toFirestore());
      _logger.i('Donation created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Create donation error: $e');
      rethrow;
    }
  }

  Future<DonationModel?> getDonation(String donationId) async {
    try {
      final doc = await _firestore
          .collection('donations')
          .doc(donationId)
          .get();
      if (doc.exists) {
        return DonationModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _logger.e('Get donation error: $e');
      rethrow;
    }
  }

  Stream<List<DonationModel>> getDonationsByCategory(String category) {
    return _firestore
        .collection('donations')
        .where('category', isEqualTo: category)
        .where('status', isEqualTo: 'available')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DonationModel.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<List<DonationModel>> searchDonations({
    String? category,
    String? location,
    bool? isUrgent,
  }) {
    Query query = _firestore
        .collection('donations')
        .where('status', isEqualTo: 'available');

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    if (isUrgent == true) {
      query = query.where('isUrgent', isEqualTo: true);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DonationModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> updateDonation(
    String donationId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection('donations').doc(donationId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.i('Donation updated: $donationId');
    } catch (e) {
      _logger.e('Update donation error: $e');
      rethrow;
    }
  }

  // Pickup Methods
  Future<String> createPickup(PickupModel pickup) async {
    try {
      final docRef = await _firestore
          .collection('pickups')
          .add(pickup.toFirestore());
      _logger.i('Pickup created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Create pickup error: $e');
      rethrow;
    }
  }

  Future<List<PickupModel>> getPickupsByVolunteer(String volunteerId) async {
    try {
      final snapshot = await _firestore
          .collection('pickups')
          .where('volunteerId', isEqualTo: volunteerId)
          .orderBy('scheduledTime', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => PickupModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      _logger.e('Get pickups error: $e');
      rethrow;
    }
  }

  Future<void> updatePickup(String pickupId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('pickups').doc(pickupId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _logger.i('Pickup updated: $pickupId');
    } catch (e) {
      _logger.e('Update pickup error: $e');
      rethrow;
    }
  }

  // Review Methods
  Future<String> createReview(ReviewModel review) async {
    try {
      final docRef = await _firestore
          .collection('reviews')
          .add(review.toFirestore());
      _logger.i('Review created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Create review error: $e');
      rethrow;
    }
  }

  Future<List<ReviewModel>> getReviewsByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('revieweeId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      _logger.e('Get reviews error: $e');
      rethrow;
    }
  }

  // Notification Methods
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _firestore
          .collection('notifications')
          .add(notification.toFirestore());
      _logger.i('Notification created');
    } catch (e) {
      _logger.e('Create notification error: $e');
      rethrow;
    }
  }

  Stream<List<NotificationModel>> getNotificationsByUser(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
      _logger.i('Notification marked as read: $notificationId');
    } catch (e) {
      _logger.e('Mark notification error: $e');
      rethrow;
    }
  }
}
