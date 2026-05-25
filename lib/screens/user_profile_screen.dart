import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../services/firebase_storage_service.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late FirestoreService firestoreService;
  late FirebaseStorageService storageService;
  late FirebaseAuthService authService;

  UserModel? userModel;
  bool isLoading = true;
  bool isEditing = false;
  File? selectedImage;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
    storageService = FirebaseStorageService();
    authService = FirebaseAuthService();

    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      final user = await firestoreService.getUser(widget.userId);
      setState(() {
        userModel = user;
        if (user != null) {
          nameController.text = user.name;
          phoneController.text = user.phone ?? '';
          addressController.text = user.address ?? '';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
    }
  }

  Future<void> saveProfile() async {
    if (userModel == null) return;

    try {
      String? profileImageUrl = userModel?.profileImageUrl;

      if (selectedImage != null) {
        profileImageUrl = await storageService.uploadProfileImage(
          imageFile: selectedImage!,
          userId: widget.userId,
        );
      }

      await firestoreService.updateUser(widget.userId, {
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'profileImageUrl': profileImageUrl,
      });

      setState(() => isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }

      await loadUserProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (userModel == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('No profile data found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : (userModel?.profileImageUrl != null
                            ? NetworkImage(userModel!.profileImageUrl!)
                            : null),
                  child:
                      selectedImage == null &&
                          userModel?.profileImageUrl == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                if (isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // User Info
            if (isEditing)
              Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: saveProfile,
                          child: const Text('Save'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => isEditing = false),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    userModel!.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userModel!.userType.toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(Icons.email, 'Email', userModel!.email),
                          const SizedBox(height: 12),
                          if (userModel!.phone != null)
                            _buildInfoRow(
                              Icons.phone,
                              'Phone',
                              userModel!.phone!,
                            ),
                          if (userModel!.address != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.location_on,
                              'Address',
                              userModel!.address!,
                            ),
                          ],
                          if (userModel!.isVerified == true) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: const [
                                Icon(Icons.verified, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Verified Account'),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (userModel!.rating != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rating & Reviews',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  '${userModel!.rating?.toStringAsFixed(1)} (${userModel!.reviewCount ?? 0} reviews)',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await authService.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF059669)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
