import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/Auth/views/sign_up_view.dart';
import 'package:chat_app_ui/features/Auth/widgets/auth_button.dart';
import 'package:chat_app_ui/features/Auth/widgets/forget_button.dart';
import 'package:chat_app_ui/features/Auth/widgets/header_text_auth.dart';
import 'package:chat_app_ui/features/Auth/widgets/normal_text_field.dart';
import 'package:chat_app_ui/features/Auth/widgets/or_login_with.dart';
import 'package:chat_app_ui/features/Auth/widgets/or_option_auth_widget.dart';
import 'package:chat_app_ui/features/Auth/widgets/secret_text_field.dart';
import 'package:chat_app_ui/features/Auth/widgets/social_buttons_icon.dart';
import 'package:chat_app_ui/features/Auth/widgets/sub_text_auth.dart';
import 'package:chat_app_ui/features/Home/views/home_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static const routeName = 'LoginView';
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailIN = TextEditingController();
  TextEditingController passwordIN = TextEditingController();

  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: ScreenSize.width / 20,
            right: ScreenSize.width / 20,
            top: ScreenSize.height / 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderTextAuthWidget(txt: "Hello, Welcome Back"),
                      SizedBox(height: ScreenSize.height / 100),
                      SubTextAuthWidget(
                        txt:
                            "Happy to see you again, to use your account please login first.",
                      ),
                      SizedBox(height: ScreenSize.height / 20),
                      NormalTextField(
                        formKey: emailFormKey,
                        controller: emailIN,
                        label: "Email Address",
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: ScreenSize.height / 30),
                    ],
                  ),
                  Positioned(
                    right: -ScreenSize.width / 30,
                    top: -ScreenSize.height / 25,
                    child: Image.asset(
                      "assets/images/avatar.png",
                      width: ScreenSize.width / 4,
                      height: ScreenSize.height / 4,
                    ),
                  ),
                ],
              ),
              SecretTextField(
                label: "Password",
                textInputType: TextInputType.visiblePassword,
                controller: passwordIN,
                formKey: passwordFormKey,
              ),
              SizedBox(height: ScreenSize.height / 40),
              ForgetButtonWidget(onTap: () {}),
              SizedBox(height: ScreenSize.height / 20),
              AuthButtonWidget(
                title: "Login",
                onTap: () {
                  Navigator.pushReplacementNamed(context, HomeView.routeName);
                },
              ),
              SizedBox(height: ScreenSize.height / 30),
              OrLoginWithWidget(),
              SizedBox(height: ScreenSize.height / 70),
              SocialButtonsIconWidget(onTapFacebook: () {}, onTapGoogle: () {}),
              SizedBox(height: ScreenSize.height / 30),
              OrOptionAuthWidget(
                question: "Don't have an account? ",
                action: "Sign Up",
                onTap: () {
                  Navigator.pushReplacementNamed(context, SignUpView.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
