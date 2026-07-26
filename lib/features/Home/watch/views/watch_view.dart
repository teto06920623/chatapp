// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:chat_app_ui/features/Home/watch/cubit/watch_cubit.dart';
import 'package:chat_app_ui/features/Home/watch/widgets/reel_player_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class WatchView extends StatelessWidget {
  const WatchView({super.key});

  // اختيار فيديو من الهاتف لرفعه
  void _pickAndUploadVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      final TextEditingController captionController = TextEditingController();

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('إضافة وصف للمقطع'),
          content: TextField(
            controller: captionController,
            decoration: const InputDecoration(hintText: 'اكتب وصفاً هنا...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<WatchCubit>().uploadReel(
                      videoFile: File(video.path),
                      caption: captionController.text.trim(),
                    );
              },
              child: const Text('نشر'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchCubit()..fetchReels(),
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => _pickAndUploadVideo(context),
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
        body: BlocConsumer<WatchCubit, WatchState>(
          listener: (context, state) {
            if (state is WatchError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is WatchLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is WatchUploading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'جاري رفع الفيديو إلى Cloudinary...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            } else if (state is WatchLoaded) {
              if (state.reels.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد مقاطع فيديو حالياً، كن أول من يشارك!',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.reels.length,
                itemBuilder: (context, index) {
                  return ReelPlayerItem(reel: state.reels[index]);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
