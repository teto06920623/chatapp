import 'package:chat_app_ui/features/Home/cubit/home_cubit.dart';
import 'package:chat_app_ui/features/Home/models/comment_model.dart';
import 'package:chat_app_ui/features/Home/widgets/post_details_view.dart'; // مكان الملف الصحيح في الـ widgets
import 'package:chat_app_ui/features/Profile/views/user_profile_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostContainer extends StatelessWidget {
  final String postId;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final String profileImage;
  final String postText;
  final String? postImage;
  final List<String> likes;
  final VoidCallback onDelete;

  const PostContainer({
    super.key,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.profileImage,
    required this.postText,
    this.postImage,
    this.likes = const [],
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final bool isLiked = likes.contains(currentUserId);
    final String formattedTime = _formatPostDate(createdAt);

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس البوست (صورة المستخدم، الاسم، وقت النشر، وزر الحذف)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage(profileImage)
                        : null,
                    child: profileImage.isEmpty
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToProfile(context),
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$formattedTime • ',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 12,
                            ),
                          ),
                          Icon(
                            Icons.public,
                            color: subTextColor,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (userId == currentUserId)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    onSelected: (value) {
                      if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'حذف البوست',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // محتوى النص
          if (postText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                postText,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

          // صورة البوست إن وجدت (تعرض كاملة وعند الضغط عليها تفتح صفحة التفاصيل)
          if (postImage != null && postImage!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsView(
                      postId: postId,
                      userName: userName,
                      userImage: profileImage,
                      postText: postText,
                      postImage: postImage!,
                      likes: likes,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                child: Image.network(
                  postImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          ],

          // شريط عدد الإعجابات والتعليقات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (likes.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${likes.length}',
                        style: TextStyle(color: subTextColor, fontSize: 13),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final int commentCount =
                        snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return Text(
                      '$commentCount تعليق',
                      style: TextStyle(color: subTextColor, fontSize: 13),
                    );
                  },
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),

          // أزرار التفاعل (إعجاب - تعليق - مشاركة)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPostActionButton(
                context,
                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                'Like',
                isLiked ? Theme.of(context).primaryColor : subTextColor,
                () {
                  context.read<HomeCubit>().toggleLike(
                        postId: postId,
                        currentLikes: likes,
                      );
                },
              ),
              _buildPostActionButton(
                context,
                Icons.mode_comment_outlined,
                'Comment',
                subTextColor,
                () {
                  _showCommentsBottomSheet(context);
                },
              ),
              _buildPostActionButton(
                context,
                Icons.share_outlined,
                'Share',
                subTextColor,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileView(
          userId: userId,
          userName: userName,
          userImage: profileImage,
        ),
      ),
    );
  }

  Widget _buildPostActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'التعليقات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('لا توجد تعليقات بعد، كن أول من يعلق!'),
                        );
                      }

                      final comments = snapshot.data!.docs
                          .map((doc) => CommentModel.fromJson(
                                doc.data() as Map<String, dynamic>,
                              ))
                          .toList();

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundImage: (comment.userImage != null &&
                                      comment.userImage!.isNotEmpty)
                                  ? NetworkImage(comment.userImage!)
                                  : null,
                              child: (comment.userImage == null ||
                                      comment.userImage!.isEmpty)
                                  ? const Icon(Icons.person, size: 18)
                                  : null,
                            ),
                            title: Text(
                              comment.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              comment.commentText,
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'اكتب تعليقاً...',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (commentController.text.trim().isNotEmpty) {
                          context.read<HomeCubit>().addComment(
                                postId: postId,
                                commentText: commentController.text,
                              );
                          commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatPostDate(DateTime dateTime) {
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
      return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
