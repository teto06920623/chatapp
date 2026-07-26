import 'package:bloc/bloc.dart';
import 'package:chat_app_ui/core/service/cache_helper.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = CacheHelper.sharedPreferences?.getBool('isDark') ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    final isCurrentlyDark = state == ThemeMode.dark;
    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    CacheHelper.sharedPreferences?.setBool('isDark', !isCurrentlyDark);
    emit(newMode);
  }
}
