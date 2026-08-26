import 'package:flutter/material.dart';
import 'package:health_care/app/theme/app_colors.dart';
import 'package:health_care/app/theme/app_gradients.dart';

import '../../models/health_data.dart';
import 'health_summary_card.dart';

class HealthSummarySection extends StatelessWidget {
  const HealthSummarySection({
    super.key,
    required this.healthSummary,
  });

  final HealthSummaryData healthSummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? AppColors.primaryBlue.withValues(alpha: 0.1)
              : theme.colorScheme.outline.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.primaryBlue.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              HealthSummaryCard(
                label: 'Steps',
                value: '${healthSummary.steps}',
                unit: 'steps',
                icon: Icons.directions_run_rounded,
                color: isDark ? AppColors.stepsDark : AppColors.stepsLight,
              ),
              HealthSummaryCard(
                label: 'Calories',
                value: '${healthSummary.caloriesBurned}',
                unit: 'kcal',
                icon: Icons.local_fire_department_rounded,
                color: isDark ? AppColors.burnedDark : AppColors.burnedLight,
              ),
              HealthSummaryCard(
                label: 'Heart Rate',
                value: '${healthSummary.heartRate}',
                unit: 'bpm',
                icon: Icons.monitor_heart_rounded,
                color: isDark ? AppColors.heartRateDark : AppColors.heartRateLight,
              ),
              HealthSummaryCard(
                label: 'Active',
                value: '${healthSummary.activeMinutes}',
                unit: 'min',
                icon: Icons.timer_rounded,
                color: isDark ? AppColors.activeDark : AppColors.activeLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
