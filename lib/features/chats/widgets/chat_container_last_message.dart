import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/chats/models/chat_last_message.dart';
import 'package:flutter/material.dart';

class ChatContainerLastMessage extends StatelessWidget {
  const ChatContainerLastMessage({
    super.key,
    required this.chatLastMessage,
    required this.onTap,
  });
  final ChatLastMessage chatLastMessage;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenSize.height / 50),
      width: double.infinity,
      height: ScreenSize.height / 12,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(ScreenSize.width / 30),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: ScreenSize.width / 15,
          backgroundImage: NetworkImage(chatLastMessage.image),
        ),
        title: Text(
          chatLastMessage.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Row(
          children: [
            Icon(
              chatLastMessage.isread
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              color: Colors.green,
              size: ScreenSize.width / 20,
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: ScreenSize.width / 3,
              child: Text(
                chatLastMessage.lastMessage,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        trailing: Text(
          chatLastMessage.time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
