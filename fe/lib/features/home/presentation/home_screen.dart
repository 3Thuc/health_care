import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/mock_home_service.dart';
import 'widgets/health_summary_section.dart';
import 'widgets/daily_nutrition_section.dart';
import 'widgets/today_workout_card.dart';
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
            HealthSummarySection(healthSummary: dashboard.healthSummary),
            const SizedBox(height: 22),
            
            // Daily Nutrition Section
            Text(
              'Daily Nutrition',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            DailyNutritionSection(dashboardData: dashboard),
            const SizedBox(height: 22),
            
            // Today's Workout Section
            Text(
              'Today\'s Workout',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            TodayWorkoutCard(
              workout: dashboard.workout,
              onStartPressed: () => _startWorkout(context),
            ),
          ],
        ),
      ),
    );
  }
}
