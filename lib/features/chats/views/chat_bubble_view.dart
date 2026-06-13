import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/chats/models/chat_last_message.dart';
import 'package:chat_app_ui/features/chats/widgets/chat_field.dart';
import 'package:chat_app_ui/features/chats/widgets/recive_message.dart';
import 'package:chat_app_ui/features/chats/widgets/sent_message.dart';
import 'package:flutter/material.dart';

class ChatBubbleView extends StatefulWidget {
  const ChatBubbleView({super.key});
  static const routeName = 'ChatBubbleView';
  @override
  State<ChatBubbleView> createState() => _ChatBubbleViewState();
}

class _ChatBubbleViewState extends State<ChatBubbleView> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final chatLastMessage =
        ModalRoute.of(context)!.settings.arguments! as ChatLastMessage;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: ScreenSize.width / 15,
              backgroundImage: NetworkImage(chatLastMessage.image),
            ),
            SizedBox(width: ScreenSize.width / 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatLastMessage.name,
                  style: Theme.of(context).textTheme.displayMedium,
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
            child: Column(
              children: [
                SentMessageWidget(
                  text:
                      "Thank you so much for your time and support. I am looking forward to your reply.",
                  time: "10:00 AM",
                  isread: true,
                ),
                ReciveMessageWidget(
                  text:
                      "Thank you so much for your time and support. I am looking forward to your reply.",
                  time: "10:00 AM",
                ),
              ],
            ),
          ),
          ChatField(controller: controller, onSend: () {}),
        ],
      ),
    );
  }
}
