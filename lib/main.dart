import 'package:chat_app_ui/core/cubit/theme_cubit.dart';
import 'package:chat_app_ui/core/service/cache_helper.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:chat_app_ui/core/utils/theme/dark_theme.dart';
import 'package:chat_app_ui/core/utils/theme/light_theme.dart';
import 'package:chat_app_ui/features/auth/cubit/auth_cubit.dart';
import 'package:chat_app_ui/features/auth/views/login_view.dart';
import 'package:chat_app_ui/features/auth/views/sign_up_view.dart';
import 'package:chat_app_ui/features/Home/cubit/home_cubit.dart';
import 'package:chat_app_ui/features/Home/views/create_text_story_view.dart';
import 'package:chat_app_ui/features/Home/views/home_view.dart';
import 'package:chat_app_ui/features/Intro/views/intro_view.dart';
import 'package:chat_app_ui/features/Search/views/search_view.dart';
import 'package:chat_app_ui/features/chats/views/chat_bubble_view.dart';
import 'package:chat_app_ui/features/chats/views/chat_home.dart';
import 'package:chat_app_ui/features/chats/views/chats_view.dart';
import 'package:chat_app_ui/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 1. إنشاء انستانس من المحلي للإشعارات
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 2. معالج الإشعارات في الخلفية عند إغلاق التطبيق
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

// 3. دالة تهيئة الإشعارات المحلية
Future<void> _initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
  );

  // إنشاء قناة الإشعارات المخصصة لأندرويد
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await CacheHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // إعداد معالج الخلفية لـ FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // طلب إذن الإشعارات
  await FirebaseMessaging.instance.requestPermission();

  // تهيئة الإشعارات المحلية
  await _initLocalNotifications();

  // الاستماع للإشعارات في الـ Foreground وإظهار البانر
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => HomeCubit()..loadHomeData()),
      ],
      child: const MyApp(),
    ),
  );
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
            CreateTextStoryView.routeName: (context) =>
                const CreateTextStoryView(),
            ChatHome.routeName: (context) => const ChatHome(),
            ChatsView.routeName: (context) => const ChatsView(),
            ChatBubbleView.routeName: (context) => const ChatBubbleView(),
            SearchView.routeName: (context) => const SearchView(),
          },
          initialRoute: FirebaseAuth.instance.currentUser != null
              ? HomeView.routeName
              : IntroView.routeName,
        );
      },
    );
  }
}
