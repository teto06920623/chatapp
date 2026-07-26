import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:chat_app_ui/features/chats/models/message_model.dart';
import 'package:chat_app_ui/features/chats/widgets/chat_field.dart';
import 'package:chat_app_ui/features/chats/widgets/recive_message.dart';
import 'package:chat_app_ui/features/chats/widgets/sent_message.dart';
import 'package:chat_app_ui/features/Home/notifications/cubit/notifications_cubit.dart'; // استيراد كيوبت الإشعارات
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubbleView extends StatefulWidget {
  const ChatBubbleView({super.key});
  static const routeName = 'ChatBubbleView';

  @override
  State<ChatBubbleView> createState() => _ChatBubbleViewState();
}

class _ChatBubbleViewState extends State<ChatBubbleView> {
  final TextEditingController controller = TextEditingController();

  String getChatId(String uId1, String uId2) {
    return uId1.compareTo(uId2) > 0 ? '${uId1}_$uId2' : '${uId2}_$uId1';
  }

  void sendMessage(String receiverId) async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final String senderId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final String chatId = getChatId(senderId, receiverId);

    controller.clear();

    final message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      messageText: text,
      timestamp: DateTime.now(),
    );

    // 1. إضافة الرسالة في قاعدة البيانات
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());

    // 2. إرسال الإشعار تلقائياً إلى الطرف الآخر
    await NotificationsCubit.sendNotification(
      receiverId: receiverId,
      title: 'رسالة جديدة',
      body: text,
      type: 'chat',
      targetId: chatId,
    );
  }

  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    final targetUser = ModalRoute.of(context)!.settings.arguments as UserModel;
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final String chatId = getChatId(currentUserId, targetUser.uid);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(
              radius: ScreenSize.width / 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: isValidUrl(targetUser.urlImage)
                  ? NetworkImage(targetUser.urlImage!)
                  : null,
              child:
                  (targetUser.urlImage == null || targetUser.urlImage!.isEmpty)
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
            ),
            SizedBox(width: ScreenSize.width / 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  targetUser.name,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
                Text(
                  "Online",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('ابدأ المحادثة الآن...'),
                  );
                }

                final messages = snapshot.data!.docs
                    .map((doc) => MessageModel.fromJson(
                          doc.data() as Map<String, dynamic>,
                        ))
                    .toList();

                return ListView.builder(
                  reverse: true, // لإظهار أحدث الرسائل بالأسفل
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final bool isMe = msg.senderId == currentUserId;
                    final timeFormatted =
                        "${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}";

                    if (isMe) {
                      return SentMessageWidget(
                        text: msg.messageText,
                        time: timeFormatted,
                        isread: true,
                      );
                    } else {
                      return ReciveMessageWidget(
                        text: msg.messageText,
                        time: timeFormatted,
                      );
                    }
                  },
                );
              },
            ),
          ),
          ChatField(
            controller: controller,
            onSend: () => sendMessage(targetUser.uid),
          ),
        ],
      ),
    );
  }
}
