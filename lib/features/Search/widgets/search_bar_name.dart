import 'package:flutter/material.dart';

class SearchBarNameWidget extends StatelessWidget {
  const SearchBarNameWidget({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: 'Search by name',
        hintStyle: Theme.of(context).textTheme.headlineMedium,
        prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
