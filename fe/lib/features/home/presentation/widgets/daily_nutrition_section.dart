import 'package:flutter/material.dart';
import 'package:health_care/app/theme/app_colors.dart';
import 'package:health_care/app/theme/app_gradients.dart';

import 'nutrition_progress_card.dart';
import '../../models/home_dashboard_data.dart';

class DailyNutritionSection extends StatelessWidget {
  const DailyNutritionSection({
    super.key,
    required this.dashboardData,
  });

  final HomeDashboardData dashboardData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.primaryCyan.withValues(alpha: 0.08)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          NutritionProgressCard(
            title: 'Calories',
            current: dashboardData.nutritionConsumed,
            target: dashboardData.nutritionTarget,
            unit: 'kcal',
            color: isDark ? AppColors.caloriesDark : AppColors.caloriesLight,
            gradientColors: const [
              Color(0xFF3B82F6),
              Color(0xFF06B6D4),
            ],
          ),
          const SizedBox(height: 10),
          NutritionProgressCard(
            title: 'Protein',
            current: 125, // Mocked for now, just like in original code
            target: 150,
            unit: 'g',
            color: isDark ? AppColors.proteinDark : AppColors.proteinLight,
            gradientColors: const [
              Color(0xFF10B981),
              Color(0xFF14B8A6),
            ],
          ),
          const SizedBox(height: 10),
          NutritionProgressCard(
            title: 'Carbs',
            current: 210,
            target: 250,
            unit: 'g',
            color: isDark ? AppColors.carbsDark : AppColors.carbsLight,
            gradientColors: const [
              Color(0xFFF59E0B),
              Color(0xFFF97316),
            ],
          ),
          const SizedBox(height: 10),
          NutritionProgressCard(
            title: 'Fat',
            current: 55,
            target: 70,
            unit: 'g',
            color: isDark ? AppColors.fatDark : AppColors.fatLight,
            gradientColors: const [
              Color(0xFF8B5CF6),
              Color(0xFFA855F7),
            ],
          ),
        ],
      ),
    );
  }
}
