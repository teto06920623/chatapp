import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:chat_app_ui/features/chats/views/chat_bubble_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});
  static const routeName = 'ChatsView';

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا يوجد مستخدمون آخرون حالياً'));
          }

          // تصفية المستخدمين واستبعاد المستخدم الحالي المسجل دخوله
          final realUsers = snapshot.data!.docs
              .map((doc) =>
                  UserModel.fromJson(doc.data() as Map<String, dynamic>))
              .where((user) => user.uid.isNotEmpty && user.uid != currentUserId)
              .toList();

          if (realUsers.isEmpty) {
            return const Center(
                child: Text('أنت المستخدم الوحيد المسجل حتى الآن'));
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.width / 20,
              vertical: 10,
            ),
            itemCount: realUsers.length,
            itemBuilder: (context, index) {
              final user = realUsers[index];
              return Container(
                margin: EdgeInsets.only(bottom: ScreenSize.height / 50),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(ScreenSize.width / 30),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ChatBubbleView.routeName,
                      arguments: user, // تمرير كائن المستخدم الحقيقي
                    );
                  },
                  leading: CircleAvatar(
                    radius: ScreenSize.width / 15,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        (user.urlImage != null && user.urlImage!.isNotEmpty)
                            ? NetworkImage(user.urlImage!)
                            : null,
                    child: (user.urlImage == null || user.urlImage!.isEmpty)
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
