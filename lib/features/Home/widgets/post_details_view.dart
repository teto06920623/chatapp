import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../models/comment_model.dart';

class PostDetailsView extends StatefulWidget {
  final String postId;
  final String userName;
  final String? userImage;
  final String postText;
  final String postImage;
  final List<String> likes;

  const PostDetailsView({
    super.key,
    required this.postId,
    required this.userName,
    this.userImage,
    required this.postText,
    required this.postImage,
    required this.likes,
  });

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // عرض الصورة بالكامل مع إمكانية التكبير (Zoom)
          Expanded(
            child: InteractiveViewer(
              child: Center(
                child: Image.network(
                  widget.postImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // تفاصيل البوست والكومنتات في الأسفل
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: Color(0xff1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                if (widget.postText.isNotEmpty)
                  Text(widget.postText,
                      style: const TextStyle(color: Colors.white70)),
                const Divider(color: Colors.grey),

                // عرض التعليقات
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final comments = snapshot.data!.docs
                          .map((doc) => CommentModel.fromJson(
                              doc.data() as Map<String, dynamic>))
                          .toList();

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            title: Text(comment.userName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13)),
                            subtitle: Text(comment.commentText,
                                style: const TextStyle(color: Colors.white70)),
                          );
                        },
                      );
                    },
                  ),
                ),

                // إضافة تعليق
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'اكتب تعليقاً...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.purple),
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          context.read<HomeCubit>().addComment(
                                postId: widget.postId,
                                commentText: _commentController.text,
                              );
                          _commentController.clear();
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
