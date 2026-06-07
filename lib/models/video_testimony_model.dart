class VideoTestimony {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int videoDuration; // in seconds
  final DateTime uploadedAt;
  final String ngoId;
  final String ngoName;
  final int views;
  final int likes;
  final bool isApproved;
  final String? approverComment;

  const VideoTestimony({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.videoDuration,
    required this.uploadedAt,
    required this.ngoId,
    required this.ngoName,
    this.views = 0,
    this.likes = 0,
    this.isApproved = false,
    this.approverComment,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'videoDuration': videoDuration,
      'uploadedAt': uploadedAt,
      'ngoId': ngoId,
      'ngoName': ngoName,
      'views': views,
      'likes': likes,
      'isApproved': isApproved,
      'approverComment': approverComment,
    };
  }

  static VideoTestimony fromFirestore(Map<String, dynamic> data) {
    return VideoTestimony(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      videoDuration: data['videoDuration'] ?? 0,
      uploadedAt: data['uploadedAt']?.toDate() ?? DateTime.now(),
      ngoId: data['ngoId'] ?? '',
      ngoName: data['ngoName'] ?? '',
      views: data['views'] ?? 0,
      likes: data['likes'] ?? 0,
      isApproved: data['isApproved'] ?? false,
      approverComment: data['approverComment'],
    );
  }
}
