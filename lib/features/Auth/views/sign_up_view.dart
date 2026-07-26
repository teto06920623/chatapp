import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/features/auth/cubit/auth_cubit.dart';
import 'package:chat_app_ui/features/auth/views/login_view.dart';
import 'package:chat_app_ui/features/auth/widgets/auth_button.dart';
import 'package:chat_app_ui/features/auth/widgets/header_text_auth.dart';
import 'package:chat_app_ui/features/auth/widgets/normal_text_field.dart';
import 'package:chat_app_ui/features/auth/widgets/or_option_auth_widget.dart';
import 'package:chat_app_ui/features/auth/widgets/secret_text_field.dart';
import 'package:chat_app_ui/features/auth/widgets/sub_text_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});
  static const routeName = "SignUpView";
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController emailUP = TextEditingController();
  TextEditingController nameUp = TextEditingController();
  TextEditingController passwordUp = TextEditingController();

  final emailFormKey = GlobalKey<FormState>();
  final nameFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },

      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Padding(
            padding: EdgeInsets.only(
              left: ScreenSize.width / 20,
              right: ScreenSize.width / 20,
              top: ScreenSize.height / 8,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerRight,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderTextAuthWidget(txt: "Hello, Let’s Get Started"),
                          SizedBox(height: ScreenSize.height / 100),
                          const SubTextAuthWidget(
                            txt: "Create your account and join us today.",
                          ),
                          SizedBox(height: ScreenSize.height / 20),
                          NormalTextField(
                            formKey: nameFormKey,
                            controller: nameUp,
                            label: "Full Name",
                            textInputType: TextInputType.name,
                          ),
                          SizedBox(height: ScreenSize.height / 30),
                        ],
                      ),
                      Positioned(
                        right: -ScreenSize.width / 30,
                        top: -ScreenSize.height / 17,
                        child: Image.asset(
                          "assets/images/avatar.png",
                          width: ScreenSize.width / 4,
                          height: ScreenSize.height / 4,
                        ),
                      ),
                    ],
                  ),
              
                  NormalTextField(
                    formKey: emailFormKey,
                    controller: emailUP,
                    label: "Email Address",
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: ScreenSize.height / 30),
              
                  SecretTextField(
                    label: "Password",
                    textInputType: TextInputType.visiblePassword,
                    controller: passwordUp,
                    formKey: passwordFormKey,
                  ),
                  SizedBox(height: ScreenSize.height / 20),
              
                  AuthButtonWidget(
                    title: "Sign Up",
                    onTap: () {
                      context.read<AuthCubit>().registerUser(
                        emailUP.text,
                        passwordUp.text,
                        nameUp.text,
                      );
                    },
                  ),
                  SizedBox(height: ScreenSize.height / 30),
                  OrOptionAuthWidget(
                    question: "Already have an account? ",
                    action: "Login",
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        LoginView.routeName,
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
