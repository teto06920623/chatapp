import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class ReciveMessageWidget extends StatelessWidget {
  const ReciveMessageWidget({
    super.key,
    required this.text,
    required this.time,
  });
  final String text;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenSize.height / 50,
        left: ScreenSize.width / 50,
        right: ScreenSize.width / 3,
      ),
      padding: EdgeInsets.all(ScreenSize.width / 50),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(ScreenSize.width / 30),
          bottomRight: Radius.circular(ScreenSize.width / 30),
          bottomLeft: Radius.circular(ScreenSize.width / 30),
        ),
      ),
      child: Column(
        children: [
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
