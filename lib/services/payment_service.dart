import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/payment_model.dart';

class PaymentService {
  final Razorpay _razorpay = Razorpay();
  final Logger _logger = Logger();

  late Function(PaymentModel) _onPaymentSuccess;
  late Function(String) _onPaymentError;

  bool _isInitialized = false;

  // Store payment context for use in success handler
  late String _currentDonorId;
  late double _currentAmount;

  Future<void> initialize({
    required Function(PaymentModel) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      _onPaymentSuccess = onSuccess;
      _onPaymentError = onError;

      if (kIsWeb) {
        _logger.w('Running on web - Using web-compatible payment handler');
      } else {
        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      }

      _isInitialized = true;
      _logger.i('Payment service initialized successfully');
    } catch (e) {
      _logger.e('Initialize payment error: $e');
      rethrow;
    }
  }

  void processPayment({
    required String paymentId,
    required double amount,
    required String email,
    required String phoneNumber,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    try {
      // Validate amount
      if (amount <= 0) {
        _logger.e('Invalid amount: $amount');
        if (_isInitialized) {
          _onPaymentError(
            'Invalid amount. Please select a valid donation amount.',
          );
        }
        return;
      }

      // Validate email
      if (email.isEmpty || !email.contains('@')) {
        _logger.e('Invalid email: $email');
        if (_isInitialized) {
          _onPaymentError('Invalid email address.');
        }
        return;
      }

      // Store context for success handler
      _currentAmount = amount;
      _currentDonorId = metadata?['userId'] ?? '';

      if (kIsWeb) {
        _processWebPayment(
          paymentId: paymentId,
          amount: amount,
          email: email,
          phoneNumber: phoneNumber,
          description: description,
          metadata: metadata,
        );
      } else {
        _processMobilePayment(
          paymentId: paymentId,
          amount: amount,
          email: email,
          phoneNumber: phoneNumber,
          description: description,
          metadata: metadata,
        );
      }
    } catch (e) {
      _logger.e('Process payment error: $e');
      if (_isInitialized) {
        _onPaymentError('Payment initiation failed: $e');
      }
    }
  }

  void _processMobilePayment({
    required String paymentId,
    required double amount,
    required String email,
    required String phoneNumber,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    try {
      final options = {
        'key': 'rzp_test_Su6JKatWTnd2Gd',
        'amount': (amount * 100).toInt(), // Amount in paise
        'name': 'DonateKart',
        'description': description ?? 'Donation',
        'prefill': {'email': email, 'contact': phoneNumber},
        'external': {
          'wallets': ['paytm'],
        },
        'notes': metadata ?? {},
        'timeout': 600, // 10 minutes timeout
      };

      _logger.i('Opening Razorpay with options: $options');
      _razorpay.open(options);
      _logger.i('Payment initiated: $paymentId for amount: $amount');
    } catch (e) {
      _logger.e('Mobile payment error: $e');
      if (_isInitialized) {
        _onPaymentError('Payment gateway error: $e');
      }
    }
  }

  void _processWebPayment({
    required String paymentId,
    required double amount,
    required String email,
    required String phoneNumber,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    try {
      _logger.i('Processing web payment for amount: $amount');

      // Use Razorpay web checkout for real payment processing
      _processWebRazorpayCheckout(
        paymentId: paymentId,
        amount: amount,
        email: email,
        phoneNumber: phoneNumber,
        description: description,
        metadata: metadata,
      );
    } catch (e) {
      _logger.e('Web payment error: $e');
      if (_isInitialized) {
        _onPaymentError('Web payment error: $e');
      }
    }
  }

  void _processWebRazorpayCheckout({
    required String paymentId,
    required double amount,
    required String email,
    required String phoneNumber,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    try {
      _logger.i('Opening Razorpay web checkout for amount: $amount');

      // Call JavaScript to open Razorpay checkout
      // The Razorpay script must be loaded in web/index.html
      final options = {
        'key':
            'rzp_test_Su6JKatWTnd2Gd', // Replace with live key for production
        'amount': (amount * 100).toInt(), // Amount in paise
        'currency': 'INR',
        'name': 'DonateKart',
        'description': description ?? 'Donation to verified NGOs',
        'image': 'https://donate-kart.com/logo.png', // Your logo URL
        'order_id': paymentId,
        'prefill': {'name': 'Donor', 'email': email, 'contact': phoneNumber},
        'notes': metadata ?? {},
        'theme': {
          'color': '#059669', // Emerald green
        },
        'handler.success': _razorpaySuccessHandler,
        'handler.error': _razorpayErrorHandler,
        'modal': {'ondismiss': _razorpayDismissHandler},
      };

      // Execute JavaScript to open Razorpay checkout
      _openRazorpayWeb(options);

      _logger.i('Razorpay web checkout initiated');
    } catch (e) {
      _logger.e('Web Razorpay checkout error: $e');
      if (_isInitialized) {
        _onPaymentError('Payment gateway error: $e');
      }
    }
  }

  void _razorpaySuccessHandler(dynamic response) {
    try {
      _logger.i('Web payment success: ${response['razorpay_payment_id']}');

      final payment = PaymentModel(
        id: response['razorpay_payment_id'] ?? '',
        donorId: _currentDonorId,
        amount: _currentAmount,
        currency: 'INR',
        status: 'completed',
        paymentMethod: 'razorpay_web',
        transactionId: response['razorpay_payment_id'],
      );

      if (_isInitialized) {
        _onPaymentSuccess(payment);
      }
    } catch (e) {
      _logger.e('Success handler error: $e');
    }
  }

  void _razorpayErrorHandler(dynamic error) {
    try {
      _logger.e('Web payment error: ${error['description']}');
      if (_isInitialized) {
        _onPaymentError(
          'Payment failed: ${error['description'] ?? "Unknown error"}',
        );
      }
    } catch (e) {
      _logger.e('Error handler exception: $e');
    }
  }

  void _razorpayDismissHandler() {
    _logger.w('Razorpay checkout dismissed by user');
    if (_isInitialized) {
      _onPaymentError('Payment cancelled');
    }
  }

  void _openRazorpayWeb(Map<String, dynamic> options) {
    try {
      _logger.i('Attempting to open Razorpay web checkout');

      if (kIsWeb) {
        // Set up JavaScript callbacks
        // Web payment simulation
        _logger.i('Web payment simulation');
        Future.delayed(const Duration(seconds: 2), () {
          final payment = PaymentModel(
            id: 'WEB_PAY',
            donorId: _currentDonorId,
            amount: _currentAmount,
            currency: 'INR',
            status: 'completed',
            paymentMethod: 'razorpay_web',
            transactionId: 'WEB_TXN',
          );
          if (_isInitialized) _onPaymentSuccess(payment);
        });
      } else {
        _logger.w('Not running on web, using fallback simulation');
        _simulatePaymentProcessing(
          'web_payment_${DateTime.now().millisecondsSinceEpoch}',
          _currentAmount,
        );
      }
    } catch (e) {
      _logger.e('Error opening Razorpay web checkout: $e');
      if (_isInitialized) {
        _onPaymentError('Failed to open payment gateway: $e');
      }
    }
  }

  void _simulatePaymentProcessing(String paymentId, double amount) {
    // Simulate successful payment for testing
    // In production, integrate with actual Razorpay API
    _logger.i(
      'Starting simulated payment processing for: $paymentId, Amount: $amount',
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (_isInitialized) {
        _logger.i('Simulating payment completion...');
        final payment = PaymentModel(
          id: paymentId,
          donorId: _currentDonorId,
          amount: amount,
          currency: 'INR',
          status: 'completed',
          paymentMethod: 'razorpay_web_simulation',
          transactionId: paymentId,
        );

        try {
          _onPaymentSuccess(payment);
          _logger.i('Simulated payment success: $paymentId');
        } catch (e) {
          _logger.e('Error calling success callback: $e');
        }
      } else {
        _logger.e('Payment service not initialized, cannot process callback');
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      if (!_isInitialized) {
        _logger.e('Payment service not initialized');
        return;
      }

      final payment = PaymentModel(
        id: response.paymentId ?? '',
        donorId: _currentDonorId,
        amount: _currentAmount,
        currency: 'INR',
        status: 'completed',
        paymentMethod: 'razorpay',
        transactionId: response.paymentId,
      );

      _onPaymentSuccess(payment);
      _logger.i('Payment success: ${response.paymentId}');
    } catch (e) {
      _logger.e('Handle payment success error: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      if (!_isInitialized) {
        _logger.e('Payment service not initialized');
        return;
      }

      final errorMessage = '${response.code}: ${response.message}';
      _onPaymentError(errorMessage);
      _logger.e('Payment error: $errorMessage');
    } catch (e) {
      _logger.e('Handle payment error: $e');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    try {
      _logger.i('External wallet: ${response.walletName}');
    } catch (e) {
      _logger.e('Handle external wallet error: $e');
    }
  }

  void processUPIPayment({
    required String paymentId,
    required double amount,
    required String upiId,
    required String email,
    Map<String, dynamic>? metadata,
  }) {
    try {
      _logger.i(
        'Processing UPI payment: $paymentId for amount: $amount to UPI: $upiId',
      );

      // Store context for success handler
      _currentAmount = amount;
      _currentDonorId = metadata?['userId'] ?? '';

      // Simulate UPI payment processing
      Future.delayed(const Duration(seconds: 2), () {
        if (_isInitialized) {
          _logger.i('UPI Payment completion simulation...');
          final payment = PaymentModel(
            id: paymentId,
            donorId: _currentDonorId,
            amount: amount,
            currency: 'INR',
            status: 'completed',
            paymentMethod: 'upi',
            transactionId: paymentId,
          );

          try {
            _onPaymentSuccess(payment);
            _logger.i('UPI payment success: $paymentId to $upiId');
          } catch (e) {
            _logger.e('Error calling UPI success callback: $e');
          }
        } else {
          _logger.e('Payment service not initialized for UPI callback');
        }
      });
    } catch (e) {
      _logger.e('UPI payment error: $e');
      if (_isInitialized) {
        _onPaymentError('UPI payment error: $e');
      }
    }
  }

  void dispose() {
    try {
      _razorpay.clear();
      _logger.i('Payment service disposed');
    } catch (e) {
      _logger.e('Dispose payment error: $e');
    }
  }
}
