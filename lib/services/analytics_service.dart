import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  final Logger _logger = Logger();

  Future<void> logAppOpen() async {
    try {
      await _firebaseAnalytics.logAppOpen();
      _logger.i('App open event logged');
    } catch (e) {
      _logger.e('Log app open error: $e');
    }
  }

  Future<void> logLogin({required String method}) async {
    try {
      await _firebaseAnalytics.logLogin(loginMethod: method);
      _logger.i('Login event logged: $method');
    } catch (e) {
      _logger.e('Log login error: $e');
    }
  }

  Future<void> logSignUp({required String method}) async {
    try {
      await _firebaseAnalytics.logSignUp(signUpMethod: method);
      _logger.i('Sign up event logged: $method');
    } catch (e) {
      _logger.e('Log sign up error: $e');
    }
  }

  Future<void> logDonationCreated({
    required String donationId,
    required String category,
    required String condition,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: 'donation_created',
        parameters: {
          'donation_id': donationId,
          'category': category,
          'condition': condition,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      _logger.i('Donation created event logged: $donationId');
    } catch (e) {
      _logger.e('Log donation created error: $e');
    }
  }

  Future<void> logDonationClaimed({
    required String donationId,
    required String claimedBy,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: 'donation_claimed',
        parameters: {
          'donation_id': donationId,
          'claimed_by': claimedBy,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      _logger.i('Donation claimed event logged: $donationId');
    } catch (e) {
      _logger.e('Log donation claimed error: $e');
    }
  }

  Future<void> logPickupScheduled({
    required String pickupId,
    required String donationId,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: 'pickup_scheduled',
        parameters: {
          'pickup_id': pickupId,
          'donation_id': donationId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      _logger.i('Pickup scheduled event logged: $pickupId');
    } catch (e) {
      _logger.e('Log pickup scheduled error: $e');
    }
  }

  Future<void> logPickupCompleted({
    required String pickupId,
    required String volunteerId,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: 'pickup_completed',
        parameters: {
          'pickup_id': pickupId,
          'volunteer_id': volunteerId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      _logger.i('Pickup completed event logged: $pickupId');
    } catch (e) {
      _logger.e('Log pickup completed error: $e');
    }
  }

  Future<void> logPaymentProcessed({
    required String paymentId,
    required double amount,
    required String currency,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: 'payment_processed',
        parameters: {
          'payment_id': paymentId,
          'amount': amount,
          'currency': currency,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      _logger.i('Payment processed event logged: $paymentId');
    } catch (e) {
      _logger.e('Log payment processed error: $e');
    }
  }

  Future<void> logReviewSubmitted({
    required String reviewId,
    required double rating,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: 'review_submitted',
        parameters: {
          'review_id': reviewId,
          'rating': rating,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      _logger.i('Review submitted event logged: $reviewId');
    } catch (e) {
      _logger.e('Log review submitted error: $e');
    }
  }

  Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      _logger.i('Custom event logged: $eventName');
    } catch (e) {
      _logger.e('Log custom event error: $e');
    }
  }

  Future<void> setUserProperties({
    required String userId,
    required String userType,
  }) async {
    try {
      await _firebaseAnalytics.setUserId(id: userId);
      await _firebaseAnalytics.setUserProperty(
        name: 'user_type',
        value: userType,
      );
      _logger.i('User properties set: $userId, $userType');
    } catch (e) {
      _logger.e('Set user properties error: $e');
    }
  }
}
