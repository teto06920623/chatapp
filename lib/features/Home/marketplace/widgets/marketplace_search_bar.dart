import 'package:flutter/material.dart';

class MarketplaceSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const MarketplaceSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff2A2A2A) : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onSearch(value.trim());
            }
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'البحث عن منتجات في Marketplace...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
