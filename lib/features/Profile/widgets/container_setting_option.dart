import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class ContainerSettingOptionWidget extends StatelessWidget {
  const ContainerSettingOptionWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ScreenSize.width / 30),
        width: ScreenSize.width,
        height: ScreenSize.height / 15,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(ScreenSize.width / 30),
        ),
        child: Row(
          children: [
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: ScreenSize.width / 15,
            ),
          ],
        ),
      ),
    );
  }
}
