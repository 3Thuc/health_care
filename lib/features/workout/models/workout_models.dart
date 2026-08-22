enum ExerciseType { STRENGTH, CARDIO, TIME_BASED, BODYWEIGHT }

class Exercise {
  const Exercise({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.targetMuscle, 
    required this.difficulty, 
    required this.equipment, 
    required this.icon, 
    this.type = ExerciseType.STRENGTH,
    this.instructions = const [], 
    this.tips = const [], 
    this.commonMistakes = const []
  });

  final String id;
  final String name;
  final String description;
  final String targetMuscle;
  final String difficulty;
  final String equipment;
  final String icon;
  final ExerciseType type;
  final List<String> instructions;
  final List<String> tips;
  final List<String> commonMistakes;
}

enum SetType { PLANNED, EXTRA }

enum SetStatus { NOT_STARTED, IN_PROGRESS, COMPLETED, SKIPPED }

class WorkoutSet {
  WorkoutSet({
    required this.id,
    required this.setNumber,
    this.status = SetStatus.NOT_STARTED,
    this.setType = SetType.PLANNED,
    this.plannedReps,
    this.actualReps,
    this.plannedWeight,
    this.actualWeight,
    this.additionalWeight,
    this.unit = 'kg',
    this.completedAt,
    this.restSeconds,
  });

  final String id;
  final int setNumber;
  final SetStatus status;
  final SetType setType;
  
  final int? plannedReps;
  final int? actualReps;
  
  final double? plannedWeight;
  final double? actualWeight;
  final double? additionalWeight; // Specifically for BODYWEIGHT
  
  final String unit;
  final DateTime? completedAt;
  final int? restSeconds;

  WorkoutSet copyWith({
    String? id,
    int? setNumber,
    SetStatus? status,
    SetType? setType,
    int? plannedReps,
    int? actualReps,
    double? plannedWeight,
    double? actualWeight,
    double? additionalWeight,
    String? unit,
    DateTime? completedAt,
    int? restSeconds,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      status: status ?? this.status,
      setType: setType ?? this.setType,
      plannedReps: plannedReps ?? this.plannedReps,
      actualReps: actualReps ?? this.actualReps,
      plannedWeight: plannedWeight ?? this.plannedWeight,
      actualWeight: actualWeight ?? this.actualWeight,
      additionalWeight: additionalWeight ?? this.additionalWeight,
      unit: unit ?? this.unit,
      completedAt: completedAt ?? this.completedAt,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }
}

class ScheduledExercise {

  final String id;
  final DateTime date;
  final String exerciseId;
  final ExerciseType exerciseType;

  // STRENGTH & BODYWEIGHT
  final int? sets;
  final int? reps;
  final int? restSeconds;

  // CARDIO
  final int? targetDurationSeconds;
  final int accumulatedDurationSeconds;
  final DateTime? currentSegmentStartedAt;
  final int? actualDurationSeconds; // total when completed

  final String notes;
  final double? targetDistanceKm;
  final bool completed;
  final List<WorkoutSet> actualSets;

  const ScheduledExercise({
    required this.id,
    required this.date,
    required this.exerciseId,
    required this.exerciseType,
    this.sets,
    this.reps,
    this.restSeconds,
    this.targetDurationSeconds,
    this.accumulatedDurationSeconds = 0,
    this.currentSegmentStartedAt,
    this.actualDurationSeconds,
    this.notes = '',
    this.targetDistanceKm,
    this.completed = false,
    this.actualSets = const [],
  });

  ScheduledExercise copyWith({
    int? sets,
    int? reps,
    int? restSeconds,
    int? targetDurationSeconds,
    int? accumulatedDurationSeconds,
    DateTime? currentSegmentStartedAt,
    bool clearSegmentStartedAt = false,
    int? actualDurationSeconds,
    String? notes,
    double? targetDistanceKm,
    bool? completed,
    List<WorkoutSet>? actualSets,
  }) {
    return ScheduledExercise(
      id: id,
      date: date,
      exerciseId: exerciseId,
      exerciseType: exerciseType,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      targetDurationSeconds: targetDurationSeconds ?? this.targetDurationSeconds,
      accumulatedDurationSeconds: accumulatedDurationSeconds ?? this.accumulatedDurationSeconds,
      currentSegmentStartedAt: clearSegmentStartedAt ? null : (currentSegmentStartedAt ?? this.currentSegmentStartedAt),
      actualDurationSeconds: actualDurationSeconds ?? this.actualDurationSeconds,
      notes: notes ?? this.notes,
      targetDistanceKm: targetDistanceKm ?? this.targetDistanceKm,
      completed: completed ?? this.completed,
      actualSets: actualSets ?? this.actualSets,
    );
  }
}

class WorkoutSchedule {
  // weekday: 1 = Monday .. 7 = Sunday
  const WorkoutSchedule({required this.weekday, required this.title, required this.isRestDay});

  final int weekday;
  final String title;
  final bool isRestDay;

  /// `title` is meaningful only for workout days. Rest is derived from state.
  String get displayTitle => isRestDay ? 'Rest' : title;

  WorkoutSchedule copyWith({String? title, bool? isRestDay}) => WorkoutSchedule(weekday: weekday, title: title ?? this.title, isRestDay: isRestDay ?? this.isRestDay);
  // Date representation for the current week (Monday-based). Useful for UI that maps schedules to specific dates.
  DateTime get date {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day).add(Duration(days: weekday - 1));
  }
}

class SessionExercise {
  const SessionExercise({required this.name, required this.muscleGroup, required this.durationMinutes, required this.sets, required this.reps, required this.level, required this.icon, required this.restSeconds, this.instructions = const []});
  final String name, muscleGroup, level, icon;
  final int durationMinutes, sets, reps, restSeconds;
  final List<String> instructions;
}

enum WorkoutStatus { PLANNED, IN_PROGRESS, COMPLETED, PARTIALLY_COMPLETED, CANCELLED }

class WorkoutSession {
  WorkoutSession({
    required this.id,
    required this.date,
    required this.name,
    this.status = WorkoutStatus.PLANNED,
    this.startedAt,
    this.completedAt,
    this.plannedDurationMinutes,
    this.actualDurationMinutes,
    this.exercises = const [],
  });

  final String id;
  final DateTime date;
  final String name;
  final WorkoutStatus status;
  
  final DateTime? startedAt;
  final DateTime? completedAt;
  
  final int? plannedDurationMinutes;
  final int? actualDurationMinutes;
  
  final List<ScheduledExercise> exercises;

  WorkoutSession copyWith({
    String? id,
    DateTime? date,
    String? name,
    WorkoutStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? plannedDurationMinutes,
    int? actualDurationMinutes,
    List<ScheduledExercise>? exercises,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      plannedDurationMinutes: plannedDurationMinutes ?? this.plannedDurationMinutes,
      actualDurationMinutes: actualDurationMinutes ?? this.actualDurationMinutes,
      exercises: exercises ?? this.exercises,
    );
  }
}
