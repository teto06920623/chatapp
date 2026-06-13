import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class UserInfoColumnWidget extends StatelessWidget {
  const UserInfoColumnWidget({
    super.key,
    required this.name,
    required this.email,
  });
  final String name;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: ScreenSize.width / 2,
          padding: EdgeInsets.all(ScreenSize.width / 50),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(ScreenSize.width / 30),
          ),
          child: Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        SizedBox(height: ScreenSize.height / 50),
        SizedBox(
          width: ScreenSize.width / 2,
          child: Text(
            email,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
