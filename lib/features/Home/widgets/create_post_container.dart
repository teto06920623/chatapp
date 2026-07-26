// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:chat_app_ui/features/Home/cubit/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostContainer extends StatefulWidget {
  const CreatePostContainer({super.key});

  @override
  State<CreatePostContainer> createState() => _CreatePostContainerState();
}

class _CreatePostContainerState extends State<CreatePostContainer> {
  final TextEditingController _postController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitPost() async {
    if (_postController.text.trim().isEmpty && _selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    await context.read<HomeCubit>().createPost(
          postText: _postController.text.trim(),
          imageFile: _selectedImage,
        );

    _postController.clear();
    setState(() {
      _selectedImage = null;
      _isLoading = false;
    });

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.photo_library,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  size: 28,
                ),
                onPressed: _isLoading ? null : _pickImage,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff2A2A2A) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isDark ? Colors.grey[800]! : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _postController,
                    textAlign: TextAlign.right,
                    enabled: !_isLoading,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: 'بم تفكر؟',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey.shade600,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: Icon(Icons.send,
                          color: Theme.of(context).primaryColor),
                      onPressed: _submitPost,
                    ),
              const SizedBox(width: 4),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  String? userImage;
                  if (snapshot.hasData && snapshot.data!.data() != null) {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    userImage = data['urlImage'];
                  }

                  return CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    backgroundImage: userImage != null && userImage.isNotEmpty
                        ? NetworkImage(userImage)
                        : null,
                    child: userImage == null || userImage.isEmpty
                        ? const Icon(Icons.person, size: 20, color: Colors.grey)
                        : null,
                  );
                },
              ),
            ],
          ),

          // معاينة الصورة المحددة قبل الرفع
          if (_selectedImage != null) ...[
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 16,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
