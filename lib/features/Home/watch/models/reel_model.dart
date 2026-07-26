import 'package:cloud_firestore/cloud_firestore.dart';

class ReelModel {
  final String reelId;
  final String userId;
  final String userName;
  final String? userImage;
  final String videoUrl;
  final String caption;
  final List<String> likes;
  final DateTime createdAt;

  ReelModel({
    required this.reelId,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.videoUrl,
    required this.caption,
    this.likes = const [],
    required this.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      reelId: json['reelId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userImage: json['userImage'],
      videoUrl: json['videoUrl'] ?? '',
      caption: json['caption'] ?? '',
      likes: json['likes'] != null ? List<String>.from(json['likes']) : [],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reelId': reelId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'videoUrl': videoUrl,
      'caption': caption,
      'likes': likes,
      'createdAt': createdAt,
    };
  }
}
