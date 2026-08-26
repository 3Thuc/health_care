import 'package:flutter/material.dart';
import 'package:health_care/app/theme/app_colors.dart';
import 'package:health_care/app/theme/app_gradients.dart';
import 'package:health_care/core/widgets/gradient_button.dart';

import '../../models/workout.dart';

class TodayWorkoutCard extends StatelessWidget {
  const TodayWorkoutCard({
    super.key,
    required this.workout,
    required this.onStartPressed,
  });

  final WorkoutSummaryData workout;
  final VoidCallback onStartPressed;

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
              ? AppColors.workoutAccentDark.withValues(alpha: 0.1)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.workoutAccentDark.withValues(
                    alpha: 0.06,
                  ),
                  blurRadius: 16,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${workout.muscleGroup} • ${workout.intensity}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      AppColors.primaryViolet.withValues(alpha: 0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${workout.durationMinutes} min',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkDivider
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (workout.completedMinutes / workout.durationMinutes).clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryHorizontal,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              onPressed: onStartPressed,
              icon: Icons.play_arrow_rounded,
              label: 'Start Workout',
            ),
          ),
        ],
      ),
    );
  }
}
