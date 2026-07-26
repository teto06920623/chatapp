import 'package:chat_app_ui/core/utils/colors.dart';
import 'package:chat_app_ui/core/utils/screen_size.dart';
import 'package:flutter/material.dart';

class AppLightTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: LightColors.primaryColor,
    scaffoldBackgroundColor: LightColors.backgroundColor,
    cardColor: Colors.white,
    fontFamily: 'IBMPlexSansArabic',
    colorScheme: const ColorScheme.light(
      primary: LightColors.primaryColor,
      surface: Colors.white,
      onSurface: LightColors.textColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LightColors.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: LightColors.textColor),
      titleTextStyle: TextStyle(
        color: LightColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'IBMPlexSansArabic',
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: LightColors.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightColors.primaryColor,
        foregroundColor: LightColors.backgroundColor,
        elevation: 0,
        minimumSize: Size(ScreenSize.width / 1.3, ScreenSize.height / 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenSize.width / 30),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xff777777), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: LightColors.primaryColor,
          width: 1.7,
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: LightColors.textColor,
          fontSize: 30,
          fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: LightColors.textColor),
      displaySmall: TextStyle(
          color: LightColors.textColor,
          fontSize: 13,
          fontWeight: FontWeight.normal),
      headlineLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: LightColors.primaryColor),
      headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: LightColors.disableColor),
      headlineSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: LightColors.primaryColor),
      bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: LightColors.textColor),
      bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: LightColors.textColor),
      titleMedium: TextStyle(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
      titleSmall: TextStyle(
          fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),
      bodySmall: TextStyle(fontSize: 9, color: LightColors.textColor),
    ),
  );
}
