import 'health_data.dart';
import 'meal.dart';
import 'workout.dart';

class QuickActionData {
  const QuickActionData({required this.label, required this.icon});

  final String label;
  final String icon;
}

class HomeDashboardData {
  const HomeDashboardData({
    required this.userName,
    required this.healthSummary,
    required this.nutritionConsumed,
    required this.nutritionTarget,
    required this.meals,
    required this.workout,
    required this.quickActions,
  });

  final String userName;
  final HealthSummaryData healthSummary;
  final int nutritionConsumed;
  final int nutritionTarget;
  final List<MealItem> meals;
  final WorkoutSummaryData workout;
  final List<QuickActionData> quickActions;
}
