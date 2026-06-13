import 'package:chat_app_ui/core/cubit/theme_cubit.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatField extends StatelessWidget {
  const ChatField({super.key, required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;
  @override
  Widget build(BuildContext context) {
    bool isDark = context.select(
      (ThemeCubit cubit) => cubit.state == ThemeMode.dark,
    );
    return Container(
      height: ScreenSize.height / 7,
      padding: const EdgeInsets.fromLTRB(28, 20, 18, 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1E1E1E) : const Color(0xffF8F8F8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.15)
                : Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    hintText: 'Type here...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              IconButton(
                onPressed: onSend,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                  size: ScreenSize.width / 15,
                ),
              ),
            ],
          ),

          const Spacer(),

          Container(
            width: 90,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
