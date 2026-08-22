import 'package:flutter/material.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/nutrition/presentation/nutrition_screen.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/workout/presentation/workout_page.dart';
import '../../features/history/presentation/history_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.themeMode, required this.onToggleThemeMode});

  final ThemeMode themeMode;
  final VoidCallback onToggleThemeMode;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  List<Widget> get _pages => [
    const HomeScreen(),
    const NutritionScreen(),
    const WorkoutPage(),
    const HistoryPage(),
    ProfilePage(
      isDarkMode: widget.themeMode == ThemeMode.dark,
      onThemeModeChanged: widget.onToggleThemeMode,
    ),
  ];

  Widget _buildTabItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _index == index;
    final selectedColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF1E40AF);
    final unselectedColor = isDark ? const Color(0xFF7B88A8) : const Color(0xFF64748B);
    final itemBgColor = isSelected
        ? (isDark ? const Color(0xFF162547) : const Color(0xFFE0ECFF))
        : Colors.transparent;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _index = index;
          });
        },
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: itemBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            height: 76,
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF0F172A),
                        Color(0xFF0B0F19),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : const LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFFF8FAFC),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
                if (isDark)
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, -8),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(0, Icons.home_rounded, 'Home', isDark),
                _buildTabItem(1, Icons.apple, 'Nutrition', isDark),
                _buildTabItem(2, Icons.fitness_center_rounded, 'Workout', isDark),
                _buildTabItem(3, Icons.bar_chart_rounded, 'Progress', isDark),
                _buildTabItem(4, Icons.person_rounded, 'Profile', isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
