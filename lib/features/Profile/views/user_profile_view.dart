import 'package:chat_app_ui/features/Home/cubit/home_cubit.dart';
import 'package:chat_app_ui/features/Home/models/post_model.dart';
import 'package:chat_app_ui/features/Home/widgets/post_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileView extends StatelessWidget {
  final String userId;
  final String userName;
  final String? userImage;

  const UserProfileView({
    super.key,
    required this.userId,
    required this.userName,
    this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(userName),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // رأس البروفايل
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: (userImage != null && userImage!.isNotEmpty)
                      ? NetworkImage(userImage!)
                      : null,
                  child: (userImage == null || userImage!.isEmpty)
                      ? const Icon(Icons.person, size: 45, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // بوستات المستخدم فقط
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('userId', isEqualTo: userId)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('لا توجد منشورات لهذا المستخدم بعد'),
                  );
                }

                final posts = snapshot.data!.docs
                    .map((doc) =>
                        PostModel.fromJson(doc.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post =
                        posts[index]; // تم التصحيح لقراءة عناصر القائمة
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: PostContainer(
                          postId: post.postId,
                          userId: post.userId,
                          userName: post.userName,
                          createdAt:
                              post.createdAt, // بدلاً من time: 'منذ قليل'
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
