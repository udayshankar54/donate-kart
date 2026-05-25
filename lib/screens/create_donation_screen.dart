import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/donation_model.dart';
import '../services/firestore_service.dart';
import '../services/firebase_storage_service.dart';

class CreateDonationScreen extends StatefulWidget {
  final String userId;

  const CreateDonationScreen({super.key, required this.userId});

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  late FirestoreService firestoreService;
  late FirebaseStorageService storageService;

  final List<File> selectedImages = [];
  bool isLoading = false;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;

  String selectedCategory = 'Books';
  String selectedCondition = 'good';
  String selectedPriority = 'medium';
  bool isUrgent = false;

  final categories = [
    'Books',
    'Clothing',
    'Electronics',
    'Furniture',
    'Toys',
    'Kitchen',
    'Sports',
    'Other',
  ];

  final conditions = ['new', 'like-new', 'good', 'fair'];
  final priorities = ['low', 'medium', 'high'];

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService();
    storageService = FirebaseStorageService();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    locationController = TextEditingController();
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> createDonation() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Upload images
      final imageUrls = await storageService.uploadMultipleImages(
        imageFiles: selectedImages,
        folder: 'donations',
      );

      // Create donation
      final donation = DonationModel(
        id: '',
        donorId: widget.userId,
        category: selectedCategory,
        title: titleController.text,
        description: descriptionController.text,
        imageUrls: imageUrls,
        condition: selectedCondition,
        status: 'available',
        location: locationController.text,
        priority: selectedPriority,
        isUrgent: isUrgent,
      );

      final donationId = await firestoreService.createDonation(donation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donation created successfully!')),
        );
        Navigator.of(context).pop({'success': true, 'donationId': donationId});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Donation'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images Section
            Text('Item Images', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (selectedImages.isEmpty)
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withValues(alpha: 0.05),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to select images'),
                      ],
                    ),
                  ),
                ),
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == selectedImages.length) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: pickImages,
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(child: Icon(Icons.add)),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(selectedImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(
                                      () => selectedImages.removeAt(index),
                                    );
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Title
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Item Title',
                hintText: 'e.g., Wooden Chair',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the item in detail...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value ?? 'Books');
              },
            ),
            const SizedBox(height: 16),

            // Condition
            DropdownButtonFormField<String>(
              initialValue: selectedCondition,
              decoration: InputDecoration(
                labelText: 'Condition',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: conditions
                  .map(
                    (cond) => DropdownMenuItem(value: cond, child: Text(cond)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedCondition = value ?? 'good');
              },
            ),
            const SizedBox(height: 16),

            // Location
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Pickup Location',
                hintText: 'Enter your pickup address',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Priority
            DropdownButtonFormField<String>(
              initialValue: selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: priorities
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedPriority = value ?? 'medium');
              },
            ),
            const SizedBox(height: 16),

            // Urgent Flag
            CheckboxListTile(
              title: const Text('Mark as Urgent'),
              value: isUrgent,
              onChanged: (value) {
                setState(() => isUrgent = value ?? false);
              },
            ),
            const SizedBox(height: 24),

            // Create Button
            ElevatedButton(
              onPressed: isLoading ? null : createDonation,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Create Donation'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
