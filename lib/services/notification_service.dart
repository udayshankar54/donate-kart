import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Logger _logger = Logger();

  Future<void> initialize() async {
    try {
      // Request permissions for iOS
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      _logger.i('FCM Token: $token');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _logger.i(
          'Foreground message received: ${message.notification?.title}',
        );
        // Handle foreground notification
      });

      // Handle background messages
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _logger.i('Message opened app: ${message.notification?.title}');
        // Handle message when app is opened from notification
      });

      // Handle terminated state messages
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _logger.i(
          'App launched from notification: ${initialMessage.notification?.title}',
        );
      }
    } catch (e) {
      _logger.e('Notification initialization error: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      _logger.e('Get token error: $e');
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e) {
      _logger.e('Subscribe topic error: $e');
      rethrow;
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.e('Unsubscribe topic error: $e');
      rethrow;
    }
  }

  void handleForegroundMessage(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('Foreground notification: ${message.notification?.title}');
      handler(message);
    });
  }

  void handleBackgroundMessageTap(Function(RemoteMessage) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('Notification tap: ${message.notification?.title}');
      handler(message);
    });
  }
}
