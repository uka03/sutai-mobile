import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _storageKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadSavedTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final savedTheme = preferences.getString(_storageKey);
    if (savedTheme == 'light') state = ThemeMode.light;
    if (savedTheme == 'dark') state = ThemeMode.dark;
  }

  Future<void> toggle() async {
    final nextTheme = state == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    state = nextTheme;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      nextTheme == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
