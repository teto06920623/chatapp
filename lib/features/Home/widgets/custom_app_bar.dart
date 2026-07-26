import 'package:chat_app_ui/features/Search/views/search_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key, required this.onMessengerPressed});

  final VoidCallback onMessengerPressed;

  @override
  Widget build(BuildContext context) {
    final Color currentThemeColor = Theme.of(context).primaryColor;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.5,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/splash icon.png',
            height: 35,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Text(
            'chatapp',
            style: TextStyle(
              color: currentThemeColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        _buildCircleButton(context, Icons.search, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchView(isInTab: false),
            ),
          );
        }),
        _buildCircleButton(context, Icons.messenger, onMessengerPressed),
      ],
      bottom: TabBar(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: currentThemeColor,
            width: 3.5,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: currentThemeColor,
        unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
        enableFeedback: true,
        tabs: [
          const Tab(icon: Icon(Icons.home_outlined, size: 28)),
          const Tab(icon: Icon(Icons.people_outline, size: 28)),
          const Tab(icon: Icon(Icons.ondemand_video, size: 28)),
          const Tab(icon: Icon(Icons.storefront, size: 28)),
          const Tab(icon: Icon(Icons.notifications_none, size: 28)),
          Tab(
            icon: StreamBuilder<DocumentSnapshot>(
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

                return Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: currentThemeColor, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    backgroundImage: userImage != null && userImage.isNotEmpty
                        ? NetworkImage(userImage)
                        : null,
                    child: userImage == null || userImage.isEmpty
                        ? const Icon(Icons.person, size: 16, color: Colors.grey)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff2A2A2A) : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 22,
        color: isDark ? Colors.white : Colors.black,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48.0);
}
