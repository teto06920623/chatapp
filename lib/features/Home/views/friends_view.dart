import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:chat_app_ui/features/Profile/views/user_profile_view.dart';
import 'package:chat_app_ui/features/chats/views/chat_bubble_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('لا يوجد مستخدمون حالياً'),
            );
          }

          // جلب المستخدمين وتصفيتهم باستبعاد حسابك الحالي
          final realUsers = snapshot.data!.docs
              .map((doc) =>
                  UserModel.fromJson(doc.data() as Map<String, dynamic>))
              .where((user) => user.uid.isNotEmpty && user.uid != currentUserId)
              .toList();

          if (realUsers.isEmpty) {
            return const Center(
              child: Text('أنت المستخدم الوحيد المسجل حتى الآن'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: realUsers.length,
            itemBuilder: (context, index) {
              final user = realUsers[index];

              return Card(
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onTap: () {
                    // فتح صفحة بروفايل المستخدم
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileView(
                          userId: user.uid,
                          userName: user.name,
                          userImage: user.urlImage,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    backgroundImage:
                        (user.urlImage != null && user.urlImage!.isNotEmpty)
                            ? NetworkImage(user.urlImage!)
                            : null,
                    child: (user.urlImage == null || user.urlImage!.isEmpty)
                        ? const Icon(Icons.person, color: Colors.grey, size: 28)
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  subtitle: Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(90, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      // فتح المحادثة مباشرة مع المستخدم
                      Navigator.pushNamed(
                        context,
                        ChatBubbleView.routeName,
                        arguments: user,
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text(
                      'مراسلة',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
