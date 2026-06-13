import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/Search/models/user_search_result.dart';
import 'package:chat_app_ui/features/Search/widgets/search_bar_name.dart';
import 'package:chat_app_ui/features/Search/widgets/user_search_tile.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});
  static const routeName = 'SearchView';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          left: ScreenSize.width / 20,
          right: ScreenSize.width / 20,
        ),
        child: Column(
          children: [
            SearchBarNameWidget(controller: controller),
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  return UserSearchTileWidget(userSearchResult: users[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<UserSearchResult> users = [
  UserSearchResult(
    name: "Laila Ahmed",
    image:
        "https://www.fluentu.com/blog/wp-content/uploads/site//4/african-american-young-mom-with-curly-hair-in-stylish-outfit-feeling-grateful-and-happy-receiving-surprise-gift-from-kid-holding-palms-on-heart-smiling.jpg",
  ),
  UserSearchResult(
    name: "Mohamed Ali",
    image:
        "https://img.magnific.com/free-photo/young-handsome-man-wearing-casual-tshirt-blue-background-happy-face-smiling-with-crossed-arms-looking-camera-positive-person_839833-12963.jpg?semt=ais_hybrid&w=740&q=80",
  ),
];
