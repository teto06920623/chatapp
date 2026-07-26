import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/views/login_view.dart';
import 'package:chat_app_ui/features/Intro/widgets/header_text_widget.dart';
import 'package:chat_app_ui/features/Intro/widgets/sub_text_widget.dart';
import 'package:flutter/material.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});
  static const routeName = "IntroView";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderTextWidget(),
            const SubTextWidget(),
            Image.asset("assets/images/intro.png"),
            SizedBox(height: ScreenSize.height / 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginView.routeName);
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: const Text(
                "Get Started",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
