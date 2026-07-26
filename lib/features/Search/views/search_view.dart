import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:chat_app_ui/features/Search/widgets/search_bar_name.dart';
import 'package:chat_app_ui/features/Search/widgets/user_search_tile.dart';
import 'package:chat_app_ui/features/chats/views/chat_bubble_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  final bool isInTab;
  const SearchView({super.key, this.isInTab = false});
  static const routeName = 'SearchView';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController controller = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // الاستماع لتغييرات النص في خانة البحث لتحديث النتائج فوراً
    controller.addListener(() {
      setState(() {
        searchQuery = controller.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: widget.isInTab
          ? null
          : AppBar(
              title: const Text('Search'),
            ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.width / 20,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchBarNameWidget(controller: controller),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد مستخدمون حالياً'),
                    );
                  }

                  // جلب وتصفية المستخدمين الحقيقيين واستبعاد المستخدم الحالي + تطبيق كلمة البحث
                  final usersList = snapshot.data!.docs
                      .map((doc) => UserModel.fromJson(
                          doc.data() as Map<String, dynamic>))
                      .where((user) =>
                          user.uid.isNotEmpty && user.uid != currentUserId)
                      .where((user) =>
                          user.name.toLowerCase().contains(searchQuery) ||
                          user.email.toLowerCase().contains(searchQuery))
                      .toList();

                  if (usersList.isEmpty) {
                    return const Center(
                      child: Text('لم يتم العثور على مستخدم بهذا الاسم'),
                    );
                  }

                  return ListView.separated(
                    itemCount: usersList.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final user = usersList[index];
                      return UserSearchTileWidget(
                        user: user,
                        onTap: () {
                          // الانتقال مباشرة إلى شاشة المحادثة عند الضغط على المستخدم
                          Navigator.pushNamed(
                            context,
                            ChatBubbleView.routeName,
                            arguments: user,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
