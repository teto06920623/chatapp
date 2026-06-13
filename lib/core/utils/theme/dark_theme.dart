import 'package:chat_app_ui/core/utils/colors.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class AppDarkTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,

    primaryColor: DarkColors.primaryColor,
    scaffoldBackgroundColor: DarkColors.backgroundColor,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkColors.primaryColor,
        foregroundColor: DarkColors.textColor,
        elevation: 0,
        minimumSize: Size(ScreenSize.width / 1.3, ScreenSize.height / 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenSize.width / 30),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xff1E1E1E),

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

      hintStyle: const TextStyle(
        color: DarkColors.disableColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),

      labelStyle: const TextStyle(
        color: DarkColors.disableColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xff3A3A3A), width: 1.5),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: DarkColors.primaryColor,
          width: 1.7,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.7),
      ),
    ),

    fontFamily: 'Poppins',

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: DarkColors.textColor,
        fontSize: 30,
        fontWeight: FontWeight.w900,
      ),

      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: DarkColors.textColor,
      ),

      displaySmall: TextStyle(
        color: DarkColors.textColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),

      headlineLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: DarkColors.primaryColor,
      ),

      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: DarkColors.disableColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: DarkColors.primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: DarkColors.textColor,
      ),

      bodyMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: DarkColors.textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      bodySmall: TextStyle(fontSize: 9, color: DarkColors.textColor),
    ),
  );
}
