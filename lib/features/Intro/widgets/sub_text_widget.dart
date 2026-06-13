import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SubTextWidget extends StatelessWidget {
  const SubTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenSize.width / 12,
        right: ScreenSize.width / 5,
        bottom: ScreenSize.height / 30,
      ),
      child: Text(
        "Helps you to contact everyone with just easy way",
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
