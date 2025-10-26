import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPrefKeyIsDark = 'pref_is_dark';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(super.initialState);

  /// Factory initializer that loads saved preference (async)
  static Future<ThemeCubit> create() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_kPrefKeyIsDark) ?? false;
    return ThemeCubit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPrefKeyIsDark, newMode == ThemeMode.dark);
  }
}
