import '../../models/workout_models.dart';

abstract class WorkoutSessionRepository {
  Future<WorkoutSession?> getActiveSession();
  Future<void> saveSession(WorkoutSession session);
  Future<List<WorkoutSession>> getCompletedSessions();
}
