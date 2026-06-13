import 'package:chat_app_ui/core/cubit/theme_cubit.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/core/utils/theme/dark_theme.dart';
import 'package:chat_app_ui/core/utils/theme/light_theme.dart';
import 'package:chat_app_ui/features/Auth/views/login_view.dart';
import 'package:chat_app_ui/features/Auth/views/sign_up_view.dart';
import 'package:chat_app_ui/features/Home/views/home_view.dart';
import 'package:chat_app_ui/features/Intro/views/intro_view.dart';
import 'package:chat_app_ui/features/chats/views/chat_bubble_view.dart';
import 'package:chat_app_ui/features/chats/views/chats_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(BlocProvider(create: (context) => ThemeCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return MaterialApp(
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            final width = mq.size.width;

            // معامل مرِن حسب الدزاين المرجعي 375dp
            final baseScale = (width / 375).clamp(0.85, 1.25);

            // إحترام إعداد المستخدم + إضافة معاملنا
            final systemFactor = mq.textScaler.scale(
              baseScale,
            ); // من إعدادات الجهاز
            final isTablet = width >= 600; // بريك بوينت بسيط
            final tunedFactor =
                (systemFactor * baseScale) * (isTablet ? 1.05 : 1.0);

            return MediaQuery(
              // نرجّع نفس الـ MediaQueryData مع تعديل عامل تكبير النص فقط
              data: mq.copyWith(textScaler: TextScaler.linear(tunedFactor)),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppLightTheme.theme,
          darkTheme: AppDarkTheme.theme,
          themeMode: mode,
          routes: {
            IntroView.routeName: (context) => const IntroView(),
            LoginView.routeName: (context) => const LoginView(),
            SignUpView.routeName: (context) => const SignUpView(),
            HomeView.routeName: (context) => const HomeView(),
            ChatsView.routeName: (context) => const ChatsView(),
            ChatBubbleView.routeName: (context) => const ChatBubbleView(),
          },
          initialRoute: IntroView.routeName,
        );
      },
    );
  }
}
