class HealthSummaryData {
  const HealthSummaryData({
    required this.steps,
    required this.stepGoal,
    required this.caloriesBurned,
    required this.calorieGoal,
    required this.heartRate,
    required this.activeMinutes,
    required this.activeGoal,
  });

  final int steps;
  final int stepGoal;
  final int caloriesBurned;
  final int calorieGoal;
  final int heartRate;
  final int activeMinutes;
  final int activeGoal;
}
