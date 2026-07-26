import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String receiverId;
  final String title;
  final String body;
  final String type; // 'chat' or 'like' or 'comment'
  final String? targetId; // chatId or postId
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.receiverId,
    required this.title,
    required this.body,
    required this.type,
    this.targetId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? 'مستخدم',
      senderImage: json['senderImage'],
      receiverId: json['receiverId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      targetId: json['targetId'],
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'receiverId': receiverId,
      'title': title,
      'body': body,
      'type': type,
      'targetId': targetId,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}
