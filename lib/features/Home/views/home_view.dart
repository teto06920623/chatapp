import 'package:chat_app_ui/features/Home/cubit/home_cubit.dart';
import 'package:chat_app_ui/features/Home/marketplace/views/marketplace_view.dart';
import 'package:chat_app_ui/features/Home/notifications/views/notifications_view.dart';
import 'package:chat_app_ui/features/Home/views/create_text_story_view.dart';
import 'package:chat_app_ui/features/Home/views/friends_view.dart';
import 'package:chat_app_ui/features/Home/watch/views/watch_view.dart';
import 'package:chat_app_ui/features/Profile/views/profile_view.dart';
import 'package:chat_app_ui/features/chats/views/chat_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/create_post_container.dart';
import '../widgets/stories_container.dart';
import '../widgets/post_container.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const routeName = 'HomeView';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.grey[200],
        appBar: CustomHomeAppBar(
          onMessengerPressed: () {
            Navigator.pushReplacementNamed(context, ChatHome.routeName);
          },
        ),
        body: TabBarView(
          children: [
            _buildHomeFeed(context),
            const FriendsView(),
            const WatchView(),
            const MarketplaceView(),
            const NotificationsView(),
            const ProfileView(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeFeed(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.posts.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const CreatePostContainer();
              } else if (index == 1) {
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    StoriesContainer(
                      stories: state.stories,
                      onAddStory: () {
                        Navigator.pushNamed(
                            context, CreateTextStoryView.routeName);
                      },
                      onDeleteStory: (storyId) {
                        context.read<HomeCubit>().deleteStory(storyId);
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }

              final post = state.posts[index - 2];
              return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PostContainer(
                    postId: post.postId,
                    userId: post.userId,
                    userName: post.userName,
                    createdAt: post.createdAt, // بدلاً من time: 'منذ قليل'
                    profileImage: post.userImage ?? '',
                    postText: post.postText,
                    postImage: post.postImage,
                    likes: post.likes,
                    onDelete: () {
                      context.read<HomeCubit>().deletePost(post.postId);
                    },
                  ));
            },
          );
        } else if (state is HomeError) {
          return Center(child: Text('خطأ: ${state.message}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
