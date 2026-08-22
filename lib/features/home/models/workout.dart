class WorkoutSummaryData {
  const WorkoutSummaryData({
    required this.name,
    required this.muscleGroup,
    required this.durationMinutes,
    required this.completedMinutes,
    required this.intensity,
  });

  final String name;
  final String muscleGroup;
  final int durationMinutes;
  final int completedMinutes;
  final String intensity;
}
