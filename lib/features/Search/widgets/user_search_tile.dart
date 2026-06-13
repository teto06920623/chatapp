import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/Search/models/user_search_result.dart';
import 'package:flutter/material.dart';

class UserSearchTileWidget extends StatelessWidget {
  const UserSearchTileWidget({super.key, required this.userSearchResult});
  final UserSearchResult userSearchResult;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenSize.height / 50,
        bottom: ScreenSize.height / 50,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: ScreenSize.width / 20,
            backgroundImage: NetworkImage(userSearchResult.image),
          ),
          SizedBox(width: ScreenSize.width / 20),
          Expanded(
            child: Text(
              userSearchResult.name,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
