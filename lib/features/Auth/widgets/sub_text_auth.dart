import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SubTextAuthWidget extends StatelessWidget {
  const SubTextAuthWidget({super.key, required this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.width / 1.5,
      child: Text(txt, style: Theme.of(context).textTheme.displaySmall),
    );
  }
}
