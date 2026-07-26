import 'package:flutter/material.dart';

class ForgetButtonWidget extends StatelessWidget {
  const ForgetButtonWidget({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTap,
          child: const Text(
            "Forgot Password",
            style: TextStyle(fontSize: 10, color: Color(0xff993F3F)),
          ),
        ),
      ],
    );
  }
}
