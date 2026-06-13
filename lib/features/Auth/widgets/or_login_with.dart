import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class OrLoginWithWidget extends StatelessWidget {
  const OrLoginWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: ScreenSize.width / 4,
          child: Divider(color: Theme.of(context).primaryColor, thickness: 0.7),
        ),
        Text("Or Login with", style: Theme.of(context).textTheme.displaySmall),
        SizedBox(
          width: ScreenSize.width / 4,
          child: Divider(color: Theme.of(context).primaryColor, thickness: 0.7),
        ),
      ],
    );
  }
}
