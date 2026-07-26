import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SocialButtonsIconWidget extends StatelessWidget {
  const SocialButtonsIconWidget({
    super.key,
    required this.onTapGoogle,
  });

  final VoidCallback onTapGoogle;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTapGoogle,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: ScreenSize.height / 16,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff2A2A2A) : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/google.png",
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Text(
              "Continue with Google",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
