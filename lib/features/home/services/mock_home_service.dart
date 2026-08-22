import '../models/home_dashboard_data.dart';
import '../models/health_data.dart';
import '../models/meal.dart';
import '../models/workout.dart';

class MockHomeService {
  const MockHomeService();

  HomeDashboardData getDashboardData() {
    return HomeDashboardData(
      userName: 'Alex Carter',
      healthSummary: const HealthSummaryData(
        steps: 8245,
        stepGoal: 10000,
        caloriesBurned: 1650,
        calorieGoal: 2200,
        heartRate: 72,
        activeMinutes: 46,
        activeGoal: 60,
      ),
      nutritionConsumed: 1850,
      nutritionTarget: 2200,
      meals: const [
        MealItem(
          title: 'Breakfast',
          subtitle: 'Chicken sandwich',
          calories: 420,
          protein: 28,
          carbs: 42,
          fat: 14,
          icon: '🥪',
          color: 0xFF2563EB,
        ),
        MealItem(
          title: 'Lunch',
          subtitle: 'Salmon bowl',
          calories: 560,
          protein: 34,
          carbs: 48,
          fat: 22,
          icon: '🥗',
          color: 0xFF0F172A,
        ),
        MealItem(
          title: 'Dinner',
          subtitle: 'Pasta primavera',
          calories: 620,
          protein: 24,
          carbs: 78,
          fat: 18,
          icon: '🍝',
          color: 0xFF3B82F6,
        ),
        MealItem(
          title: 'Snacks',
          subtitle: 'Greek yogurt',
          calories: 180,
          protein: 15,
          carbs: 14,
          fat: 8,
          icon: '🥣',
          color: 0xFF64748B,
        ),
      ],
      workout: const WorkoutSummaryData(
        name: 'Upper Body Strength',
        muscleGroup: 'Chest + Back',
        durationMinutes: 45,
        completedMinutes: 24,
        intensity: 'Moderate',
      ),
      quickActions: const [
        QuickActionData(label: 'Add Food', icon: '🍽️'),
        QuickActionData(label: 'Scan Food', icon: '📷'),
        QuickActionData(label: 'Start Workout', icon: '💪'),
        QuickActionData(label: 'Schedule Workout', icon: '🗓️'),
      ],
    );
  }
}
