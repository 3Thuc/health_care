import '../../models/workout_models.dart';

abstract class WorkoutScheduleRepository {
  Future<List<WorkoutSchedule>> getSchedules();
  Future<List<ScheduledExercise>> getScheduledExercises();
  Future<void> saveSchedule(WorkoutSchedule schedule);
  Future<void> saveScheduledExercise(ScheduledExercise exercise);
  Future<void> deleteScheduledExercise(String id);
}
