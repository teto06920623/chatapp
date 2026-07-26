import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String userId;
  final String userName;
  final String? userImage;
  final String commentText;
  final DateTime createdAt;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.commentText,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userImage: json['userImage'],
      commentText: json['commentText'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'commentText': commentText,
      'createdAt': createdAt,
    };
  }
}
