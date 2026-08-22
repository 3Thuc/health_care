import 'package:flutter/material.dart';

/// Centralized gradient definitions for the RGB-inspired design system.
/// Provides theme-aware gradients for cards, buttons, progress bars, and accents.
class AppGradients {
  AppGradients._();

  // ─── PRIMARY RGB GRADIENT (Cyan → Blue → Violet) ─────────────────────
  static const List<Color> primaryStops = [
    Color(0xFF06B6D4), // Cyan
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Violet
  ];

  static const LinearGradient primaryGradient = LinearGradient(
    colors: primaryStops,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryHorizontal = LinearGradient(
    colors: primaryStops,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ─── FEATURE ACCENT GRADIENTS ────────────────────────────────────────

  /// Nutrition: Emerald → Cyan
  static const LinearGradient nutritionGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Workout: Orange → Pink
  static const LinearGradient workoutGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Health: Rose → Fuchsia
  static const LinearGradient healthGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFD946EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── CARD SURFACE GRADIENTS ──────────────────────────────────────────

  static LinearGradient cardGradientLight = LinearGradient(
    colors: [
      Colors.white,
      const Color(0xFFF0F0FF).withValues(alpha: 0.7), // Soft lavender tint
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    colors: [
      Color(0xFF0F1A2E), // Deep navy
      Color(0xFF141B2F), // Slightly lighter
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── PROGRESS BAR GRADIENTS ──────────────────────────────────────────

  /// Calories progress: Blue → Cyan
  static const LinearGradient caloriesProgress = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
  );

  /// Protein progress: Emerald → Teal
  static const LinearGradient proteinProgress = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
  );

  /// Carbs progress: Amber → Orange
  static const LinearGradient carbsProgress = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
  );

  /// Fat progress: Purple → Violet
  static const LinearGradient fatProgress = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
  );

  // ─── GLOW / NEON SHADOWS (Dark Mode) ─────────────────────────────────

  static List<BoxShadow> neonGlow(Color color, {double intensity = 0.35, double blur = 20}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: blur,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.4),
        blurRadius: blur * 2,
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> primaryGlow({double intensity = 0.3}) {
    return neonGlow(const Color(0xFF3B82F6), intensity: intensity);
  }

  // ─── GLASSMORPHISM BORDER ────────────────────────────────────────────

  static Border glassBorder(Brightness brightness) {
    final isD = brightness == Brightness.dark;
    return Border.all(
      color: isD
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.white.withValues(alpha: 0.6),
      width: 1,
    );
  }

  // ─── BOTTOM NAV GLOW ────────────────────────────────────────────────

  static LinearGradient navIndicatorGradient = const LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ─── HELPER: Card gradient by theme brightness ──────────────────────

  static LinearGradient cardGradient(Brightness brightness) {
    return brightness == Brightness.dark ? cardGradientDark : cardGradientLight;
  }

  // ─── ICON GRADIENT BOX DECORATION ───────────────────────────────────

  static BoxDecoration iconGradientDecoration(Color color, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color.withValues(alpha: isDark ? 0.25 : 0.15),
          color.withValues(alpha: isDark ? 0.10 : 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shape: BoxShape.circle,
      boxShadow: isDark
          ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12, spreadRadius: 0)]
          : [],
    );
  }
}
