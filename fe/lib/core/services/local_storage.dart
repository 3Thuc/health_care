import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show MissingPluginException;

class LocalStorage {
  LocalStorage._internal();

  static final LocalStorage instance = LocalStorage._internal();
  static bool pluginAvailable = true;

  static const _mealsKey = 'meals_data';

  Future<Map<String, List<Map<String, dynamic>>>> _readAllMeals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_mealsKey);
      if (raw == null || raw.isEmpty) return {};
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, List<Map<String, dynamic>>.from(v as List)));
    } on MissingPluginException catch (_) {
      // Plugin not registered on this platform (hot-reload after adding plugin).
      // Return empty map so the app continues to work until user restarts.
      pluginAvailable = false;
      print('LocalStorage: shared_preferences plugin missing; returning empty meals');
      return {};
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> readAllMeals() async => _readAllMeals();

  Future<List<Map<String, dynamic>>> getMealsForDate(DateTime date) async {
    final all = await _readAllMeals();
    final key = _keyFor(date);
    return all[key] ?? [];
  }

  Future<void> saveMealsForDate(DateTime date, List<Map<String, dynamic>> meals) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final all = await _readAllMeals();
      all[_keyFor(date)] = meals;
      await prefs.setString(_mealsKey, jsonEncode(all));
    } on MissingPluginException catch (_) {
      pluginAvailable = false;
      print('LocalStorage: shared_preferences plugin missing; save skipped');
    }
  }

  Future<void> seedIfEmpty(Map<String, List<Map<String, dynamic>>> seedData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_mealsKey);
      if (raw == null || raw.isEmpty) {
        await prefs.setString(_mealsKey, jsonEncode(seedData));
      }
    } on MissingPluginException catch (_) {
      pluginAvailable = false;
      print('LocalStorage: shared_preferences plugin missing; seed skipped');
    }
  }

  // Workout schedule persistence (list of maps)
  static const _schedulesKey = 'workout_schedules';

  Future<List<Map<String, dynamic>>> readSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_schedulesKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List;
      return List<Map<String, dynamic>>.from(decoded.map((e) => Map<String, dynamic>.from(e as Map)));
    } on MissingPluginException catch (_) {
      pluginAvailable = false;
      print('LocalStorage: shared_preferences plugin missing; returning empty schedules');
      return [];
    }
  }

  Future<void> saveSchedules(List<Map<String, dynamic>> schedules) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_schedulesKey, jsonEncode(schedules));
    } on MissingPluginException catch (_) {
      pluginAvailable = false;
      print('LocalStorage: shared_preferences plugin missing; save schedules skipped');
    }
  }

  String _keyFor(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
