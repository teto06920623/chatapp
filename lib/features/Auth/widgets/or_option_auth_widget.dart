import 'package:flutter/material.dart';

class OrOptionAuthWidget extends StatelessWidget {
  const OrOptionAuthWidget({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });
  final String question;
  final String action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: Theme.of(context).textTheme.displaySmall),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
