import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._internal();

  static final ThemeController instance = ThemeController._internal();

  static const _prefKey = 'theme_mode';

  ThemeMode _current = ThemeMode.dark; // default to Dark on first install

  ThemeMode get currentThemeMode => _current;

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_prefKey);
    if (value == null) {
      _current = ThemeMode.dark;
      notifyListeners();
      return;
    }
    _current = _stringToThemeMode(value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _current) return;
    _current = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _themeModeToString(mode));
  }

  Future<void> toggle() async {
    await setThemeMode(_current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  static ThemeMode _stringToThemeMode(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
