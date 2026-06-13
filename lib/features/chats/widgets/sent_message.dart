import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SentMessageWidget extends StatelessWidget {
  const SentMessageWidget({
    super.key,
    required this.text,
    required this.time,
    required this.isread,
  });
  final String text;
  final String time;
  final bool isread;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenSize.height / 50,
        left: ScreenSize.width / 3,
        right: ScreenSize.width / 50,
      ),
      padding: EdgeInsets.all(ScreenSize.width / 50),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ScreenSize.width / 30),
          bottomRight: Radius.circular(ScreenSize.width / 30),
          bottomLeft: Radius.circular(ScreenSize.width / 30),
        ),
      ),
      child: Column(
        children: [
          Text(text, style: Theme.of(context).textTheme.titleMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(time, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 5),
              Icon(
                isread ? Icons.done_all : Icons.done,
                color: isread ? Colors.green : Colors.grey,
                size: ScreenSize.width / 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
