import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SecretTextField extends StatefulWidget {
  const SecretTextField({
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
  State<SecretTextField> createState() => _SecretTextFieldState();
}

class _SecretTextFieldState extends State<SecretTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(ScreenSize.height / 80),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        Form(
          key: widget.formKey,
          child: TextFormField(
            obscureText: obscureText,
            controller: widget.controller,
            cursorColor: Theme.of(context).primaryColor,
            style: Theme.of(context).textTheme.displaySmall,
            keyboardType: widget.textInputType,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Must be enter the ${widget.label}';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
