import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class HeaderTextWidget extends StatelessWidget {
  const HeaderTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenSize.width / 8,
        top: ScreenSize.height / 10,
        bottom: ScreenSize.height / 30,
      ),
      child: Text(
        "Get Closer To EveryOne",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}
