import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../main/presentation/main_shell.dart';
import '../features/nutrition/presentation/providers/nutrition_provider.dart';
import '../features/workout/presentation/providers/workout_provider.dart';
import '../core/services/local_storage.dart';

class HealthCareApp extends StatefulWidget {
  const HealthCareApp({super.key});

  @override
  State<HealthCareApp> createState() => _HealthCareAppState();
}

class _HealthCareAppState extends State<HealthCareApp> {
  ThemeMode _themeMode = ThemeController.instance.currentThemeMode;

  void _toggleThemeMode() {
    ThemeController.instance.toggle();
  }

  @override
  void initState() {
    super.initState();
    ThemeController.instance.addListener(_onThemeChanged);
    ThemeController.instance.loadSavedTheme();
    _seedLocalStorage();
  }

  Future<void> _seedLocalStorage() async {
    final storage = LocalStorage.instance;
    final defaultData = {
      '2026-08-11': [
        {'meal': 'Breakfast', 'name': 'Chicken Sandwich', 'quantity': '1 serving', 'calories': 420, 'protein': 28, 'carbs': 42, 'fat': 14},
        {'meal': 'Lunch', 'name': 'Salmon Bowl', 'quantity': '1 bowl', 'calories': 560, 'protein': 34, 'carbs': 48, 'fat': 22},
        {'meal': 'Dinner', 'name': 'Pasta Primavera', 'quantity': '1 serving', 'calories': 620, 'protein': 24, 'carbs': 78, 'fat': 18},
        {'meal': 'Extras', 'name': 'Greek Yogurt', 'quantity': '1 cup', 'calories': 180, 'protein': 15, 'carbs': 14, 'fat': 8},
      ],
      '2026-08-12': [
        {'meal': 'Breakfast', 'name': 'Avocado Toast', 'quantity': '2 slices', 'calories': 340, 'protein': 14, 'carbs': 30, 'fat': 16},
        {'meal': 'Lunch', 'name': 'Turkey Wrap', 'quantity': '1 wrap', 'calories': 470, 'protein': 27, 'carbs': 46, 'fat': 19},
      ],
      '2026-08-13': [
        {'meal': 'Breakfast', 'name': 'Oatmeal', 'quantity': '1 bowl', 'calories': 300, 'protein': 10, 'carbs': 54, 'fat': 5},
        {'meal': 'Lunch', 'name': 'Grilled Chicken Salad', 'quantity': '1 bowl', 'calories': 450, 'protein': 35, 'carbs': 20, 'fat': 18},
        {'meal': 'Dinner', 'name': 'Beef Stir Fry', 'quantity': '1 plate', 'calories': 580, 'protein': 40, 'carbs': 45, 'fat': 22},
      ],
    };
    await storage.seedIfEmpty(defaultData);
  }

  void _onThemeChanged() {
    setState(() {
      _themeMode = ThemeController.instance.currentThemeMode;
    });
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NutritionProvider()), ChangeNotifierProvider(create: (_) => WorkoutProvider())],
      child: MaterialApp(
        title: 'PulseFit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: MainShell(
          themeMode: _themeMode,
          onToggleThemeMode: _toggleThemeMode,
        ),
      ),
    );
  }
}
