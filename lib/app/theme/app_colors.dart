import 'package:flutter/material.dart';

class AppColors {
  // ─── PRIMARY RGB GRADIENT ANCHORS ────────────────────────────────────
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryViolet = Color(0xFF8B5CF6);

  // BRAND (kept for backward-compat; now = gradient mid-point)
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF67B2FF);
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryVariant = Color(0xFF1D4ED8);
  static const Color primaryTint = Color(0xFFDBEAFE);

  // SECONDARY
  static const Color secondary = Color(0xFF06B6D4);

  // ─── LIGHT THEME ────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F6FA); // Subtle cool-gray with lavender tint
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F0FF); // Soft lavender tint
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // ─── DARK THEME ─────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF050A18); // Deep space navy
  static const Color darkSurface = Color(0xFF0F1A2E); // Dark navy with blue tint
  static const Color darkSurfaceVariant = Color(0xFF162035); // Slightly lighter navy
  static const Color darkTextPrimary = Color(0xFFF0F4FF); // Slightly blue-white
  static const Color darkTextSecondary = Color(0xFF8B9CC7); // Muted blue-gray
  static const Color darkDivider = Color(0xFF1E2D4A); // Dark blue divider

  // ─── FEEDBACK ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // DARK FEEDBACK (brighter for dark backgrounds)
  static const Color successDark = Color(0xFF34D399);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color errorDark = Color(0xFFF87171);

  // ─── NUTRITION COLORS ───────────────────────────────────────────────
  // Calories: Blue → Cyan
  static const Color caloriesLight = Color(0xFF3B82F6);
  static const Color caloriesDark = Color(0xFF67B2FF);

  // Protein: Emerald → Teal
  static const Color proteinLight = Color(0xFF10B981);
  static const Color proteinDark = Color(0xFF34D399);

  // Carbs: Amber → Orange
  static const Color carbsLight = Color(0xFFF59E0B);
  static const Color carbsDark = Color(0xFFFBBF24);

  // Fat: Violet → Purple
  static const Color fatLight = Color(0xFF8B5CF6);
  static const Color fatDark = Color(0xFFA78BFA);

  // ─── WORKOUT ACCENTS ────────────────────────────────────────────────
  static const Color workoutAccentLight = Color(0xFFF97316); // Orange
  static const Color workoutAccentDark = Color(0xFFFB923C);
  static const Color workoutCompletedLight = Color(0xFF10B981);
  static const Color workoutCompletedDark = Color(0xFF34D399);
  static const Color workoutRestLight = Color(0xFF64748B);
  static const Color workoutRestDark = Color(0xFF8B9CC7);

  // ─── NEON GLOW COLORS (Dark Mode only) ──────────────────────────────
  static const Color neonCyan = Color(0xFF22D3EE);
  static const Color neonBlue = Color(0xFF60A5FA);
  static const Color neonViolet = Color(0xFFA78BFA);
  static const Color neonPink = Color(0xFFF472B6);
  static const Color neonEmerald = Color(0xFF34D399);

  // ─── HEALTH METRIC COLORS (with separate light/dark) ────────────────
  static const Color stepsLight = Color(0xFF06B6D4);
  static const Color stepsDark = Color(0xFF22D3EE);

  static const Color heartRateLight = Color(0xFFF43F5E);
  static const Color heartRateDark = Color(0xFFFB7185);

  static const Color activeLight = Color(0xFF10B981);
  static const Color activeDark = Color(0xFF34D399);

  static const Color burnedLight = Color(0xFFF97316);
  static const Color burnedDark = Color(0xFFFB923C);

  // Misc
  static const Color transparentBlack = Color(0x80000000);
}
