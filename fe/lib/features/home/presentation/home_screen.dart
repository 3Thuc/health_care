import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_care/app/theme/app_colors.dart';
import 'package:health_care/app/theme/app_gradients.dart';

import '../services/mock_home_service.dart';
import 'widgets/health_summary_card.dart';
import 'widgets/nutrition_progress_card.dart';
import '../../workout/presentation/workout_session_page.dart';

import 'package:provider/provider.dart';
import '../../workout/presentation/providers/workout_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _startWorkout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Start Workout'),
        content: const Text('Start this workout session now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Start'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (ok == true) {
      if (!context.mounted) return;
      final provider = context.read<WorkoutProvider>();
      await provider.startWorkout();
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const WorkoutSessionPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = const MockHomeService().getDashboardData();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final todayLabel = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, ${dashboard.userName} 👋',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        todayLabel,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Health Summary Section
            Container(
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
                        value: '${dashboard.healthSummary.steps}',
                        unit: 'steps',
                        icon: Icons.directions_run_rounded,
                        color: isDark
                            ? AppColors.stepsDark
                            : AppColors.stepsLight,
                      ),
                      HealthSummaryCard(
                        label: 'Calories',
                        value: '${dashboard.healthSummary.caloriesBurned}',
                        unit: 'kcal',
                        icon: Icons.local_fire_department_rounded,
                        color: isDark
                            ? AppColors.burnedDark
                            : AppColors.burnedLight,
                      ),
                      HealthSummaryCard(
                        label: 'Heart Rate',
                        value: '${dashboard.healthSummary.heartRate}',
                        unit: 'bpm',
                        icon: Icons.monitor_heart_rounded,
                        color: isDark
                            ? AppColors.heartRateDark
                            : AppColors.heartRateLight,
                      ),
                      HealthSummaryCard(
                        label: 'Active',
                        value: '${dashboard.healthSummary.activeMinutes}',
                        unit: 'min',
                        icon: Icons.timer_rounded,
                        color: isDark
                            ? AppColors.activeDark
                            : AppColors.activeLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            // Daily Nutrition Section
            Text(
              'Daily Nutrition',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Container(
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
                    current: dashboard.nutritionConsumed,
                    target: dashboard.nutritionTarget,
                    unit: 'kcal',
                    color: isDark
                        ? AppColors.caloriesDark
                        : AppColors.caloriesLight,
                    gradientColors: const [
                      Color(0xFF3B82F6),
                      Color(0xFF06B6D4),
                    ],
                  ),
                  const SizedBox(height: 10),
                  NutritionProgressCard(
                    title: 'Protein',
                    current: 125,
                    target: 150,
                    unit: 'g',
                    color: isDark
                        ? AppColors.proteinDark
                        : AppColors.proteinLight,
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
            ),
            const SizedBox(height: 22),
            // Today's Workout Section
            Text(
              'Today\'s Workout',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Container(
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
                              dashboard.workout.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dashboard.workout.muscleGroup} • ${dashboard.workout.intensity}',
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
                          '${dashboard.workout.durationMinutes} min',
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
                          widthFactor:
                              (dashboard.workout.completedMinutes /
                                      dashboard.workout.durationMinutes)
                                  .clamp(0.0, 1.0),
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
                    child: _GradientButton(
                      onPressed: () => _startWorkout(context),
                      icon: Icons.play_arrow_rounded,
                      label: 'Start Workout',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A button with gradient background using the primary RGB gradient.
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isDark ? AppGradients.primaryGlow(intensity: 0.2) : [],
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
