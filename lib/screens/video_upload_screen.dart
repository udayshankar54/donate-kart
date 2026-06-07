import 'package:flutter/material.dart';
import '../models/video_testimony_model.dart';

class AppColors {
  static const emerald = Color(0xFF059669);
  static const emeraldDark = Color(0xFF047857);
  static const emeraldLight = Color(0xFF10B981);
  static const emeraldSoft = Color(0xFFD1FAE5);
  static const slate = Color(0xFF0F172A);
  static const slateLight = Color(0xFF64748B);
  static const surface = Color(0xFFF8FAFC);
}

class VideoUploadScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final List<Map<String, String>> ngoOptions;
  final Function(VideoTestimony) onVideoSubmit;

  const VideoUploadScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.ngoOptions,
    required this.onVideoSubmit,
  });

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedNgoId;
  String? _selectedNgoName;
  String? _videoPath;
  String? _videoDuration;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _pickVideo() {
    // In a real Flutter app, you would use:
    // final _picker = ImagePicker();
    // final video = await _picker.pickVideo(source: ImageSource.gallery);
    // For now, showing a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Video picker would work on actual device. Using demo mode for web.',
        ),
      ),
    );
  }

  void _recordVideo() {
    // In a real Flutter app, you would use:
    // final _picker = ImagePicker();
    // final video = await _picker.pickVideo(source: ImageSource.camera);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Video recording would work on actual device. Using demo mode for web.',
        ),
      ),
    );
  }

  void _submitVideo() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    if (_selectedNgoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an NGO')));
      return;
    }

    if (_videoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or record a video')),
      );
      return;
    }

    setState(() => _isUploading = true);

    // Simulate upload progress
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _uploadProgress = 0.3);
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _uploadProgress = 0.7);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final videoTestimony = VideoTestimony(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: widget.userId,
          userName: widget.userName,
          userEmail: widget.userEmail,
          title: _titleController.text,
          description: _descriptionController.text,
          videoUrl: _videoPath ?? '',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=400&q=80',
          videoDuration: int.tryParse(_videoDuration ?? '0') ?? 60,
          uploadedAt: DateTime.now(),
          ngoId: _selectedNgoId ?? '',
          ngoName: _selectedNgoName ?? '',
        );

        widget.onVideoSubmit(videoTestimony);
        setState(() => _isUploading = false);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Share Your Story',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.emeraldSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.emerald),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: AppColors.emerald),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Share Your Impact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.emerald,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Upload a 1-minute video showing the impact of donations and stories of needful people.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.emerald.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Video Selection Section
            const Text(
              'Select or Record Video',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.image),
                    label: const Text('Choose Video'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _recordVideo,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Record Video'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.emeraldDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Video Selected Indicator
            if (_videoPath != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Video Selected',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Duration: $_videoDuration seconds (Max 60s)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.video_library, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        'No video selected',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Video Title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: 'e.g., How donations changed our lives',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.emerald,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share the story behind this video...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.emerald,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // NGO Selection
            const Text(
              'Select NGO Partner',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedNgoId,
                underline: const SizedBox(),
                hint: const Text('Choose an NGO'),
                items: widget.ngoOptions.map((ngo) {
                  return DropdownMenuItem(
                    value: ngo['id'],
                    onTap: () {
                      setState(() {
                        _selectedNgoName = ngo['name'];
                      });
                    },
                    child: Text(ngo['name'] ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedNgoId = value);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Upload Progress
            if (_isUploading)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.emerald,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                ],
              ),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isUploading ? null : _submitVideo,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isUploading ? 'Uploading...' : 'Share Video',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isUploading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
