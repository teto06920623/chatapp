import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SocialButtonsIconWidget extends StatelessWidget {
  const SocialButtonsIconWidget({
    super.key,
    required this.onTapFacebook,
    required this.onTapGoogle,
  });
  final VoidCallback onTapFacebook;
  final VoidCallback onTapGoogle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTapFacebook,
          child: Image.asset(
            "assets/images/facebook.png",
            height: ScreenSize.height / 20,
            width: ScreenSize.height / 20,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: ScreenSize.width / 20),
        GestureDetector(
          onTap: onTapGoogle,
          child: Image.asset(
            "assets/images/google.png",
            height: ScreenSize.height / 25,
            width: ScreenSize.height / 25,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
