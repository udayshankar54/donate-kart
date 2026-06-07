import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../models/donation_model.dart';
import '../models/pickup_model.dart';
import '../models/review_model.dart';
import '../models/notification_model.dart';
import '../models/video_testimony_model.dart';

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

  // NGO Methods
  /// Fetch all NGO partners
  Future<List<Map<String, dynamic>>> getAllNgos() async {
    try {
      final snapshot = await _firestore.collection('ngos').get();
      _logger.i('Fetched ${snapshot.docs.length} NGOs');
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      _logger.e('Get all NGOs error: $e');
      rethrow;
    }
  }

  /// Fetch NGOs by specific category/cause
  Future<List<Map<String, dynamic>>> getNgosByCategory(String cause) async {
    try {
      final snapshot = await _firestore
          .collection('ngos')
          .where('cause', isEqualTo: cause)
          .get();
      _logger.i('Fetched ${snapshot.docs.length} NGOs for cause: $cause');
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      _logger.e('Get NGOs by category error: $e');
      rethrow;
    }
  }

  /// Fetch NGOs by city/location
  Future<List<Map<String, dynamic>>> getNgosByCity(String city) async {
    try {
      final snapshot = await _firestore
          .collection('ngos')
          .where('city', isEqualTo: city)
          .get();
      _logger.i('Fetched ${snapshot.docs.length} NGOs for city: $city');
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      _logger.e('Get NGOs by city error: $e');
      rethrow;
    }
  }

  /// Fetch NGOs by category and city
  Future<List<Map<String, dynamic>>> getNgosByCategoryAndCity(
    String cause,
    String city,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('ngos')
          .where('cause', isEqualTo: cause)
          .where('city', isEqualTo: city)
          .get();
      _logger.i(
        'Fetched ${snapshot.docs.length} NGOs for cause: $cause, city: $city',
      );
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      _logger.e('Get NGOs by category and city error: $e');
      rethrow;
    }
  }

  /// Get unique NGO causes/categories
  Future<List<String>> getUniqueCauses() async {
    try {
      final snapshot = await _firestore.collection('ngos').get();
      final causes = <String>{};
      for (var doc in snapshot.docs) {
        final cause = doc.data()['cause'] as String?;
        if (cause != null) causes.add(cause);
      }
      _logger.i('Found ${causes.length} unique causes');
      return causes.toList();
    } catch (e) {
      _logger.e('Get unique causes error: $e');
      rethrow;
    }
  }

  /// Create or update an NGO partner
  Future<String> createOrUpdateNgo(
    String id,
    Map<String, dynamic> ngoData,
  ) async {
    try {
      await _firestore.collection('ngos').doc(id).set(ngoData);
      _logger.i('NGO created/updated: $id');
      return id;
    } catch (e) {
      _logger.e('Create/update NGO error: $e');
      rethrow;
    }
  }

  /// Delete an NGO partner
  Future<void> deleteNgo(String id) async {
    try {
      await _firestore.collection('ngos').doc(id).delete();
      _logger.i('NGO deleted: $id');
    } catch (e) {
      _logger.e('Delete NGO error: $e');
      rethrow;
    }
  }

  // Video Testimony Methods
  /// Create a new video testimony
  Future<String> createVideoTestimony(VideoTestimony video) async {
    try {
      final docRef = await _firestore
          .collection('video_testimonies')
          .add(video.toFirestore());
      _logger.i('Video testimony created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Create video testimony error: $e');
      rethrow;
    }
  }

  /// Get all approved video testimonies
  Stream<List<VideoTestimony>> getApprovedVideoTestimonies() {
    return _firestore
        .collection('video_testimonies')
        .where('isApproved', isEqualTo: true)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VideoTestimony.fromFirestore(doc.data()))
              .toList(),
        );
  }

  /// Get video testimonies by NGO ID
  Stream<List<VideoTestimony>> getVideoTestimoniesByNgo(String ngoId) {
    return _firestore
        .collection('video_testimonies')
        .where('ngoId', isEqualTo: ngoId)
        .where('isApproved', isEqualTo: true)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VideoTestimony.fromFirestore(doc.data()))
              .toList(),
        );
  }

  /// Get video testimonies by user ID
  Stream<List<VideoTestimony>> getVideoTestimoniesByUser(String userId) {
    return _firestore
        .collection('video_testimonies')
        .where('userId', isEqualTo: userId)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VideoTestimony.fromFirestore(doc.data()))
              .toList(),
        );
  }

  /// Get pending video testimonies (for admin approval)
  Stream<List<VideoTestimony>> getPendingVideoTestimonies() {
    return _firestore
        .collection('video_testimonies')
        .where('isApproved', isEqualTo: false)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VideoTestimony.fromFirestore(doc.data()))
              .toList(),
        );
  }

  /// Update video testimony views
  Future<void> incrementVideoTestimonyViews(String videoId) async {
    try {
      await _firestore.collection('video_testimonies').doc(videoId).update({
        'views': FieldValue.increment(1),
      });
      _logger.i('Video testimony views incremented: $videoId');
    } catch (e) {
      _logger.e('Increment views error: $e');
      rethrow;
    }
  }

  /// Update video testimony likes
  Future<void> incrementVideoTestimonyLikes(String videoId) async {
    try {
      await _firestore.collection('video_testimonies').doc(videoId).update({
        'likes': FieldValue.increment(1),
      });
      _logger.i('Video testimony likes incremented: $videoId');
    } catch (e) {
      _logger.e('Increment likes error: $e');
      rethrow;
    }
  }

  /// Approve video testimony (admin)
  Future<void> approveVideoTestimony(String videoId, {String? comment}) async {
    try {
      await _firestore.collection('video_testimonies').doc(videoId).update({
        'isApproved': true,
        'approverComment': comment,
      });
      _logger.i('Video testimony approved: $videoId');
    } catch (e) {
      _logger.e('Approve video testimony error: $e');
      rethrow;
    }
  }

  /// Reject video testimony (admin)
  Future<void> rejectVideoTestimony(
    String videoId, {
    required String reason,
  }) async {
    try {
      await _firestore.collection('video_testimonies').doc(videoId).delete();
      _logger.i('Video testimony rejected and deleted: $videoId');
    } catch (e) {
      _logger.e('Reject video testimony error: $e');
      rethrow;
    }
  }

  /// Delete video testimony
  Future<void> deleteVideoTestimony(String videoId) async {
    try {
      await _firestore.collection('video_testimonies').doc(videoId).delete();
      _logger.i('Video testimony deleted: $videoId');
    } catch (e) {
      _logger.e('Delete video testimony error: $e');
      rethrow;
    }
  }
}
