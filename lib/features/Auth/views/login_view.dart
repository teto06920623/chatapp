import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/cubit/auth_cubit.dart';
import 'package:chat_app_ui/features/auth/views/sign_up_view.dart';
import 'package:chat_app_ui/features/auth/widgets/auth_button.dart';
import 'package:chat_app_ui/features/auth/widgets/forget_button.dart';
import 'package:chat_app_ui/features/auth/widgets/header_text_auth.dart';
import 'package:chat_app_ui/features/auth/widgets/normal_text_field.dart';
import 'package:chat_app_ui/features/auth/widgets/or_login_with.dart';
import 'package:chat_app_ui/features/auth/widgets/or_option_auth_widget.dart';
import 'package:chat_app_ui/features/auth/widgets/secret_text_field.dart';
import 'package:chat_app_ui/features/auth/widgets/social_buttons_icon.dart';
import 'package:chat_app_ui/features/auth/widgets/sub_text_auth.dart';
import 'package:chat_app_ui/features/Home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
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
                          const HeaderTextAuthWidget(
                              txt: "Hello, Welcome Back"),
                          SizedBox(height: ScreenSize.height / 100),
                          const SubTextAuthWidget(
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
                      if (emailFormKey.currentState!.validate() &&
                          passwordFormKey.currentState!.validate()) {
                        context.read<AuthCubit>().loginUser(
                              email: emailIN.text,
                              password: passwordIN.text,
                            );
                      }
                    },
                  ),
                  SizedBox(height: ScreenSize.height / 30),
                  const OrLoginWithWidget(),
                  SizedBox(height: ScreenSize.height / 70),
                  SocialButtonsIconWidget(
                    onTapGoogle: () {
                      context.read<AuthCubit>().LoginWithGoogle();
                    },
                  ),
                  SizedBox(height: ScreenSize.height / 30),
                  OrOptionAuthWidget(
                    question: "Don't have an account? ",
                    action: "Sign Up",
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        SignUpView.routeName,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
