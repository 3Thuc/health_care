import '../../models/workout_models.dart';
import 'exercise_repository.dart';
import 'workout_schedule_repository.dart';
import 'workout_session_repository.dart';

DateTime day(DateTime value) => DateTime(value.year, value.month, value.day);

class MockExerciseRepository implements ExerciseRepository {
  @override
  Future<List<Exercise>> getExercises() async => _exercises;

  static const _exercises = [
    Exercise(id: 'bench', name: 'Bench Press', description: 'A foundational barbell press for building chest strength.', targetMuscle: 'Chest', difficulty: 'Intermediate', equipment: 'Barbell', icon: '🏋️', instructions: ['Lie with feet grounded.', 'Lower the bar with control.', 'Press upward and keep shoulders stable.'], tips: ['Keep wrists stacked over elbows.'], commonMistakes: ['Bouncing the bar off your chest.']),
    Exercise(id: 'incline', name: 'Incline Bench Press', description: 'Upper chest pressing movement.', targetMuscle: 'Chest', difficulty: 'Intermediate', equipment: 'Barbell', icon: '↗️'),
    Exercise(id: 'pushup', name: 'Push Up', description: 'A versatile bodyweight chest exercise.', targetMuscle: 'Chest', difficulty: 'Beginner', equipment: 'Bodyweight', type: ExerciseType.BODYWEIGHT, icon: '💪'),
    Exercise(id: 'fly', name: 'Chest Fly', description: 'Controlled isolation movement for the chest.', targetMuscle: 'Chest', difficulty: 'Beginner', equipment: 'Dumbbell', icon: '🪽'),
    Exercise(id: 'pullup', name: 'Pull Ups', description: 'Bodyweight vertical pull for the back.', targetMuscle: 'Back', difficulty: 'Intermediate', equipment: 'Bodyweight', type: ExerciseType.BODYWEIGHT, icon: '⬆️'),
    Exercise(id: 'pulldown', name: 'Lat Pulldown', description: 'Machine pull to train the lats.', targetMuscle: 'Back', difficulty: 'Beginner', equipment: 'Machine', icon: '🔽'),
    Exercise(id: 'row', name: 'Barbell Row', description: 'Compound horizontal pull.', targetMuscle: 'Back', difficulty: 'Advanced', equipment: 'Barbell', icon: '🚣'),
    Exercise(id: 'cableRow', name: 'Seated Cable Row', description: 'Cable row for mid-back control.', targetMuscle: 'Back', difficulty: 'Intermediate', equipment: 'Cable', icon: '🔗'),
    Exercise(id: 'press', name: 'Shoulder Press', description: 'Overhead press for strong shoulders.', targetMuscle: 'Shoulders', difficulty: 'Beginner', equipment: 'Dumbbell', icon: '🙌'),
    Exercise(id: 'lateral', name: 'Lateral Raise', description: 'Side delt isolation movement.', targetMuscle: 'Shoulders', difficulty: 'Beginner', equipment: 'Dumbbell', icon: '↔️'),
    Exercise(id: 'front', name: 'Front Raise', description: 'Front delt isolation movement.', targetMuscle: 'Shoulders', difficulty: 'Beginner', equipment: 'Dumbbell', icon: '⬆️'),
    Exercise(id: 'facepull', name: 'Face Pull', description: 'Cable pull for rear delts and posture.', targetMuscle: 'Shoulders', difficulty: 'Intermediate', equipment: 'Cable', icon: '🎯'),
    Exercise(id: 'squat', name: 'Squat', description: 'Compound lower-body strength exercise.', targetMuscle: 'Legs', difficulty: 'Advanced', equipment: 'Barbell', icon: '🦵'),
    Exercise(id: 'legpress', name: 'Leg Press', description: 'Machine-based leg strength movement.', targetMuscle: 'Legs', difficulty: 'Beginner', equipment: 'Machine', icon: '🛷'),
    Exercise(id: 'rdl', name: 'Romanian Deadlift', description: 'Hip hinge for hamstrings.', targetMuscle: 'Legs', difficulty: 'Intermediate', equipment: 'Barbell', icon: '🏋️'),
    Exercise(id: 'legcurl', name: 'Leg Curl', description: 'Machine hamstring isolation.', targetMuscle: 'Legs', difficulty: 'Beginner', equipment: 'Machine', icon: '🦿'),
    Exercise(id: 'curl', name: 'Bicep Curl', description: 'Classic elbow flexion exercise.', targetMuscle: 'Arms', difficulty: 'Beginner', equipment: 'Dumbbell', icon: '💪'),
    Exercise(id: 'hammer', name: 'Hammer Curl', description: 'Neutral-grip bicep and forearm work.', targetMuscle: 'Arms', difficulty: 'Beginner', equipment: 'Dumbbell', icon: '🔨'),
    Exercise(id: 'pushdown', name: 'Tricep Pushdown', description: 'Cable exercise for the triceps.', targetMuscle: 'Arms', difficulty: 'Beginner', equipment: 'Cable', icon: '⬇️'),
    Exercise(id: 'skull', name: 'Skull Crusher', description: 'Lying tricep extension.', targetMuscle: 'Arms', difficulty: 'Intermediate', equipment: 'Barbell', icon: '⚡'),
    Exercise(id: 'plank', name: 'Plank', description: 'Static core stability exercise.', targetMuscle: 'Core', difficulty: 'Beginner', equipment: 'Bodyweight', type: ExerciseType.BODYWEIGHT, icon: '🧘'),
    Exercise(id: 'crunch', name: 'Crunch', description: 'Simple abdominal flexion exercise.', targetMuscle: 'Core', difficulty: 'Beginner', equipment: 'Bodyweight', type: ExerciseType.BODYWEIGHT, icon: '🔄'),
    Exercise(id: 'legraise', name: 'Leg Raise', description: 'Lower-ab focused core movement.', targetMuscle: 'Core', difficulty: 'Intermediate', equipment: 'Bodyweight', type: ExerciseType.BODYWEIGHT, icon: '📐'),
    Exercise(id: 'running', name: 'Running', description: 'Steady cardiovascular training.', targetMuscle: 'Cardio', difficulty: 'Beginner', equipment: 'Bodyweight', type: ExerciseType.CARDIO, icon: '🏃'),
    Exercise(id: 'cycling', name: 'Cycling', description: 'Low-impact cardiovascular training.', targetMuscle: 'Cardio', difficulty: 'Beginner', equipment: 'Machine', type: ExerciseType.CARDIO, icon: '🚴'),
  ];
}

class MockWorkoutScheduleRepository implements WorkoutScheduleRepository {
  MockWorkoutScheduleRepository() {
    // seed a weekly repeating schedule (weekday: 1..7)
    _schedules = [
      WorkoutSchedule(weekday: 1, title: 'Chest + Triceps', isRestDay: false),
      WorkoutSchedule(weekday: 2, title: 'Back + Biceps', isRestDay: false),
      WorkoutSchedule(weekday: 3, title: '', isRestDay: true),
      WorkoutSchedule(weekday: 4, title: 'Shoulders', isRestDay: false),
      WorkoutSchedule(weekday: 5, title: 'Legs', isRestDay: false),
      WorkoutSchedule(weekday: 6, title: 'Cardio', isRestDay: false),
      WorkoutSchedule(weekday: 7, title: '', isRestDay: true),
    ];

    // scheduled exercises still use concrete dates for seeded data (this is sample data)
    final start = day(DateTime.now()).subtract(Duration(days: DateTime.now().weekday - 1));
    _scheduled = [
      _s(start, 'bench', ExerciseType.STRENGTH, sets: 4, reps: 10, rest: 90),
      _s(start, 'incline', ExerciseType.STRENGTH, sets: 3, reps: 10, rest: 90),
      _s(start, 'pushdown', ExerciseType.STRENGTH, sets: 3, reps: 12, rest: 60),
      _s(start.add(const Duration(days: 1)), 'pullup', ExerciseType.BODYWEIGHT, sets: 3, reps: 8, rest: 90),
      _s(start.add(const Duration(days: 1)), 'pulldown', ExerciseType.STRENGTH, sets: 4, reps: 10, rest: 90),
      _s(start.add(const Duration(days: 1)), 'row', ExerciseType.STRENGTH, sets: 4, reps: 8, rest: 90),
      _s(start.add(const Duration(days: 3)), 'press', ExerciseType.STRENGTH, sets: 4, reps: 10, rest: 90),
      _s(start.add(const Duration(days: 3)), 'lateral', ExerciseType.STRENGTH, sets: 3, reps: 12, rest: 60),
      _s(start.add(const Duration(days: 4)), 'squat', ExerciseType.STRENGTH, sets: 4, reps: 10, rest: 120),
      _s(start.add(const Duration(days: 4)), 'legpress', ExerciseType.STRENGTH, sets: 4, reps: 12, rest: 90),
      _s(start.add(const Duration(days: 5)), 'running', ExerciseType.CARDIO, targetDurationSeconds: 1800),
    ];
  }
  late List<WorkoutSchedule> _schedules;
  late List<ScheduledExercise> _scheduled;
  static int _counter = 20;
  static ScheduledExercise _s(DateTime date, String id, ExerciseType type, {int? sets, int? reps, int? rest, int? targetDurationSeconds}) {
    return ScheduledExercise(
      id: 'seed-${_counter++}', 
      date: date, 
      exerciseId: id, 
      exerciseType: type,
      sets: sets, 
      reps: reps, 
      restSeconds: rest, 
      targetDurationSeconds: targetDurationSeconds,
    );
  }
  @override Future<List<WorkoutSchedule>> getSchedules() async => List.of(_schedules);
  @override Future<List<ScheduledExercise>> getScheduledExercises() async => List.of(_scheduled);
  @override
  Future<void> saveSchedule(WorkoutSchedule schedule) async {
    _schedules = [..._schedules.where((item) => item.weekday != schedule.weekday), schedule];
  }
  @override Future<void> saveScheduledExercise(ScheduledExercise exercise) async { _scheduled = [..._scheduled.where((item) => item.id != exercise.id), exercise]; }
  @override Future<void> deleteScheduledExercise(String id) async { _scheduled.removeWhere((item) => item.id == id); }
}
class MockWorkoutSessionRepository implements WorkoutSessionRepository {
  WorkoutSession? _activeSession;
  List<WorkoutSession> _sessions = [];

  @override
  Future<WorkoutSession?> getActiveSession() async => _activeSession;

  @override
  Future<void> saveSession(WorkoutSession session) async {
    if (session.status == WorkoutStatus.IN_PROGRESS) {
      _activeSession = session;
    } else {
      _activeSession = null;
      _sessions.add(session);
    }
  }

  @override
  Future<List<WorkoutSession>> getCompletedSessions() async => List.of(_sessions);
}
