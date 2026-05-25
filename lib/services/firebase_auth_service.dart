import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;
  final Logger _logger = Logger();

  FirebaseAuthService() {
    // Configure GoogleSignIn based on platform.
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    } else {
      // NOTE: On native Android/iOS, hardcoding a Client ID can cause token mismatches.
      // If your google-services.json or GoogleService-Info.plist is configured correctly,
      // you can often instantiate GoogleSignIn() without passing an explicit clientId.
      _googleSignIn = GoogleSignIn(
        clientId: '388233580989-u5m7v6j8k3q2p1o0n9m8l7k6j5i4h3g2.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );
    }
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String userType,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      _logger.i('User signed up: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign up error: ${e.message}');
      rethrow;
    }
  }

  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.i('User logged in: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('Login error: ${e.message}');
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Force sign-out from Google first to clear any expired cached tokens
      _logger.i('Clearing cached Google session to guarantee a fresh token...');
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        _logger.i('Google sign in cancelled by user');
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Log token availability for easier remote debugging
      _logger.d('Google ID Token empty: ${googleSignInAuthentication.idToken == null}');
      _logger.d('Google Access Token empty: ${googleSignInAuthentication.accessToken == null}');

      // Validate tokens before creating credential
      if (googleSignInAuthentication.idToken == null) {
        throw FirebaseAuthException(
          code: 'INVALID_TOKEN',
          message: 'ID token is null from Google Sign-in. Check your SHA-1 key configuration in Firebase Console!',
        );
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Perform authentication with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      _logger.i('User signed in with Google successfully: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase Auth Exception [${e.code}]: ${e.message}');
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        _logger.w('CRITICAL: This error usually means your local SHA-1 fingerprint is missing or mismatched in the Firebase Console Settings.');
      }
      rethrow;
    } catch (e) {
      _logger.e('Google sign in unexpected error: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _logger.i('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      _logger.e('Password reset error: ${e.message}');
      rethrow;
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(FirebaseAuthException) onError,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          _logger.i('Phone verification completed');
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.e('Phone verification failed: ${e.message}');
          onError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          _logger.i('Verification code sent to: $phoneNumber');
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _logger.i('Code auto-retrieval timeout');
        },
      );
    } catch (e) {
      _logger.e('Phone verification error: $e');
      rethrow;
    }
  }

  Future<void> updatePhoneNumberWithCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _firebaseAuth.currentUser?.updatePhoneNumber(credential);
      _logger.i('Phone number updated successfully');
    } on FirebaseAuthException catch (e) {
      _logger.e('Phone update error: ${e.message}');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      _logger.i('User logged out');
    } catch (e) {
      _logger.e('Logout error: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      _logger.i('Account deleted');
    } on FirebaseAuthException catch (e) {
      _logger.e('Account deletion error: ${e.message}');
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }
}