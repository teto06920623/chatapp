// ignore_for_file: deprecated_member_use

import 'package:chat_app_ui/features/Home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTextStoryView extends StatefulWidget {
  const CreateTextStoryView({super.key});
  static const routeName = 'CreateTextStoryView';

  @override
  State<CreateTextStoryView> createState() => _CreateTextStoryViewState();
}

class _CreateTextStoryViewState extends State<CreateTextStoryView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1877F2), // لون خلفية فيسبوك الشهير
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.25),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if (_textController.text.trim().isNotEmpty) {
                  // حفظ الستوري في فايربيس عبر الكيوبت
                  context.read<HomeCubit>().createStory(
                        storyText: _textController.text.trim(),
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'تم',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: TextField(
            controller: _textController,
            maxLines: null,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'اكتب أو ضع @إشارة',
              hintStyle: TextStyle(
                color: Colors.white60,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
