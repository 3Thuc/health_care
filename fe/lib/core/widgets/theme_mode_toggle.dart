import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';

class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({super.key, required this.isDarkMode, required this.onChanged});

  final bool isDarkMode;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode
        ? AppColors.darkSurfaceVariant
        : const Color(0xFFE8ECF8); // Soft lavender for light
    final knobGradient = isDarkMode
        ? const LinearGradient(colors: [Color(0xFF1A2744), Color(0xFF0F1A2E)])
        : const LinearGradient(colors: [Colors.white, Color(0xFFF8F9FF)]);
    final activeIconColor = isDarkMode
        ? AppColors.neonCyan
        : const Color(0xFFF59E0B);
    final inactiveIconColor = isDarkMode
        ? AppColors.darkTextSecondary
        : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: 124,
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isDarkMode
                ? AppColors.primaryBlue.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? AppColors.primaryBlue.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: knobGradient,
                  shape: BoxShape.circle,
                  boxShadow: isDarkMode
                      ? AppGradients.neonGlow(AppColors.neonCyan, intensity: 0.15, blur: 10)
                      : [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6)],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 180),
                      scale: isDarkMode ? 0.92 : 1,
                      child: Icon(Icons.light_mode_rounded, size: 20, color: isDarkMode ? inactiveIconColor : activeIconColor),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 180),
                      scale: isDarkMode ? 1 : 0.92,
                      child: Icon(Icons.dark_mode_rounded, size: 20, color: isDarkMode ? activeIconColor : inactiveIconColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
