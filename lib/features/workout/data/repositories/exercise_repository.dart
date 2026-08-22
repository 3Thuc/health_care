import '../../models/workout_models.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getExercises();
}
