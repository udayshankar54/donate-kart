import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final Logger _logger = Logger();
  static const uuid = Uuid();

  Future<String> uploadImage({
    required File imageFile,
    required String folder,
    String? fileName,
  }) async {
    try {
      fileName ??= '${uuid.v4()}.jpg';
      final ref = _firebaseStorage.ref('$folder/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      _logger.i('Image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      _logger.e('Upload image error: $e');
      rethrow;
    }
  }

  Future<List<String>> uploadMultipleImages({
    required List<File> imageFiles,
    required String folder,
  }) async {
    try {
      final uploadTasks = <Future<String>>[];

      for (var imageFile in imageFiles) {
        uploadTasks.add(uploadImage(imageFile: imageFile, folder: folder));
      }

      final urls = await Future.wait(uploadTasks);
      _logger.i('Multiple images uploaded: ${urls.length} images');
      return urls;
    } catch (e) {
      _logger.e('Upload multiple images error: $e');
      rethrow;
    }
  }

  Future<void> deleteImage({required String imageUrl}) async {
    try {
      final ref = _firebaseStorage.refFromURL(imageUrl);
      await ref.delete();
      _logger.i('Image deleted: $imageUrl');
    } catch (e) {
      _logger.e('Delete image error: $e');
      rethrow;
    }
  }

  Future<void> deleteMultipleImages({required List<String> imageUrls}) async {
    try {
      final deleteTasks = <Future<void>>[];

      for (var imageUrl in imageUrls) {
        deleteTasks.add(deleteImage(imageUrl: imageUrl));
      }

      await Future.wait(deleteTasks);
      _logger.i('Multiple images deleted: ${imageUrls.length} images');
    } catch (e) {
      _logger.e('Delete multiple images error: $e');
      rethrow;
    }
  }

  Future<String> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    try {
      final ref = _firebaseStorage.ref('profile_images/$userId/profile.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      _logger.i('Profile image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      _logger.e('Upload profile image error: $e');
      rethrow;
    }
  }

  Future<String> uploadDonationImage({
    required File imageFile,
    required String donationId,
  }) async {
    try {
      final fileName = '${uuid.v4()}.jpg';
      final ref = _firebaseStorage.ref('donations/$donationId/$fileName');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      _logger.i('Donation image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      _logger.e('Upload donation image error: $e');
      rethrow;
    }
  }

  Future<String> uploadPickupProofImage({
    required File imageFile,
    required String pickupId,
  }) async {
    try {
      final fileName = '${uuid.v4()}.jpg';
      final ref = _firebaseStorage.ref('pickups/$pickupId/proof/$fileName');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      _logger.i('Pickup proof image uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      _logger.e('Upload pickup proof image error: $e');
      rethrow;
    }
  }
}
