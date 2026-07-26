import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userId;
  final String userName;
  final String? userImage;
  final String postText;
  final String? postImage;
  final List<String> likes; // قائمة الـ User IDs للإعجابات
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.postText,
    this.postImage,
    this.likes = const [],
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userImage: json['userImage'],
      postText: json['postText'] ?? '',
      postImage: json['postImage'],
      likes: json['likes'] != null ? List<String>.from(json['likes']) : [],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'postText': postText,
      'postImage': postImage,
      'likes': likes,
      'createdAt': createdAt,
    };
  }
}
