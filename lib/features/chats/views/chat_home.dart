import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/Home/views/home_view.dart';
import 'package:chat_app_ui/features/chats/views/chats_view.dart';
import 'package:chat_app_ui/features/Profile/views/profile_view.dart';
import 'package:chat_app_ui/features/Search/views/search_view.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});
  static const routeName = "ChatHome";
  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Navigator.pushReplacementNamed(context, HomeView.routeName);
            },
          ),
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
                tabs: const [
                  Tab(text: 'Chats'),
                  Tab(text: 'Search'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: TabBarView(
                children: [
                  ChatsView(),
                  SearchView(isInTab: true),
                  ProfileView()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatPostDate(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'منذ لحظات';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      if (minutes == 1) return 'منذ دقيقة';
      if (minutes == 2) return 'منذ دقيقتين';
      if (minutes >= 3 && minutes <= 10) return 'منذ $minutes دقائق';
      return 'منذ $minutes دقيقة';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      if (hours == 1) return 'منذ ساعة';
      if (hours == 2) return 'منذ ساعتين';
      if (hours >= 3 && hours <= 10) return 'منذ $hours ساعات';
      return 'منذ $hours ساعة';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      if (days == 1) return 'منذ يوم';
      if (days == 2) return 'منذ يومين';
      if (days >= 3 && days <= 10) return 'منذ $days أيام';
      return 'منذ $days يوم';
    } else {
      // إذا مر أكثر من أسبوع يتم عرض التاريخ بالشكل: 2026/07/26
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
