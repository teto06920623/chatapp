import 'package:chat_app_ui/core/utils/colors.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class NormalTextField extends StatelessWidget {
  const NormalTextField({
    super.key,
    required this.label,
    required this.textInputType,
    required this.controller,
    required this.formKey,
  });
  final String label;
  final TextInputType textInputType;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ScreenSize.height / 80),
          child: Text(label, style: Theme.of(context).textTheme.displaySmall),
        ),
        Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            cursorColor: LightColors.primaryColor,
            style: Theme.of(context).textTheme.displaySmall,
            keyboardType: textInputType,
            decoration: InputDecoration(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Must be enter the $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
