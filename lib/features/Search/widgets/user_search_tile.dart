import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:flutter/material.dart';

class UserSearchTileWidget extends StatelessWidget {
  const UserSearchTileWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  final UserModel user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ScreenSize.height / 80,
          horizontal: ScreenSize.width / 40,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: ScreenSize.width / 18,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  (user.urlImage != null && user.urlImage!.isNotEmpty)
                      ? NetworkImage(user.urlImage!)
                      : null,
              child: (user.urlImage == null || user.urlImage!.isEmpty)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            SizedBox(width: ScreenSize.width / 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chat,
              color: Theme.of(context).primaryColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
