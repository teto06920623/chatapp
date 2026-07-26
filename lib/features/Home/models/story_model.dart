import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String storyId;
  final String userId;
  final String userName;
  final String? userImage;
  final String? mediaUrl;
  final String? storyText;
  final DateTime createdAt;

  StoryModel({
    required this.storyId,
    required this.userId,
    required this.userName,
    this.userImage,
    this.mediaUrl,
    this.storyText,
    required this.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      storyId: json['storyId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userImage: json['userImage'],
      mediaUrl: json['mediaUrl'],
      storyText: json['storyText'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'mediaUrl': mediaUrl,
      'storyText': storyText,
      'createdAt': createdAt,
    };
  }
}
