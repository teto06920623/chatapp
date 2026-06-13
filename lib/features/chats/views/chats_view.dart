import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/chats/models/chat_last_message.dart';
import 'package:chat_app_ui/features/chats/views/chat_bubble_view.dart';
import 'package:chat_app_ui/features/chats/widgets/chat_container_last_message.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});
  static const routeName = 'ChatsView';
  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          left: ScreenSize.width / 20,
          right: ScreenSize.width / 20,
        ),
        child: Column(
          children: [
            ChatContainerLastMessage(
              chatLastMessage: chatLastMessages[0],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatBubbleView.routeName,
                  arguments: chatLastMessages[0],
                );
              },
            ),
            ChatContainerLastMessage(
              chatLastMessage: chatLastMessages[1],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatBubbleView.routeName,
                  arguments: chatLastMessages[1],
                );
              },
            ),
            ChatContainerLastMessage(
              chatLastMessage: chatLastMessages[2],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatBubbleView.routeName,
                  arguments: chatLastMessages[2],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<ChatLastMessage> chatLastMessages = [
  ChatLastMessage(
    image:
        "https://www.mnp.ca/-/media/foundation/integrations/personnel/2020/12/16/13/57/personnel-image-4483.jpg?h=800&iar=0&w=600&hash=833D605FDB6AC3C2D2915F6BF8B4ADA4",
    name: "John Doe",
    lastMessage: "Hello, How are you ?",
    time: "12:00 PM",
    isread: true,
  ),
  ChatLastMessage(
    image:
        "https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg",
    name: "Harry Potter",
    lastMessage: "Let's go to Hogwarts !",
    time: "12:09 PM",
    isread: false,
  ),
  ChatLastMessage(
    image:
        "https://www.fluentu.com/blog/wp-content/uploads/site//4/african-american-young-mom-with-curly-hair-in-stylish-outfit-feeling-grateful-and-happy-receiving-surprise-gift-from-kid-holding-palms-on-heart-smiling.jpg",
    name: "Laila Ahmed",
    lastMessage: "Go to Easy Learn Academy !",
    time: "02:56 AM",
    isread: false,
  ),
];
