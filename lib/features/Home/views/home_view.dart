import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/chats/views/chats_view.dart';
import 'package:chat_app_ui/features/Profile/views/profile_view.dart';
import 'package:chat_app_ui/features/Search/views/search_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const routeName = "HomeView";
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            "Easy Chat",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: TabBar(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                isScrollable: true,
                //labelColor: Theme.of(context).primaryColor,
                labelStyle: Theme.of(context).textTheme.headlineLarge,
                unselectedLabelStyle: Theme.of(
                  context,
                ).textTheme.headlineMedium,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.width / 10,
                ),
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(text: 'Chats'),
                  Tab(text: 'Search'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Expanded(
              child: TabBarView(
                children: [ChatsView(), SearchView(), ProfileView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
