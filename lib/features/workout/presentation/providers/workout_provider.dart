import 'package:flutter/foundation.dart';
import '../../data/repositories/mock_workout_repositories.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/repositories/workout_schedule_repository.dart';
import '../../data/repositories/workout_session_repository.dart';
import '../../models/workout_models.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutProvider({
    ExerciseRepository? exerciseRepository,
    WorkoutScheduleRepository? scheduleRepository,
    WorkoutSessionRepository? sessionRepository,
  })  : _exerciseRepository = exerciseRepository ?? MockExerciseRepository(),
        _scheduleRepository = scheduleRepository ?? MockWorkoutScheduleRepository(),
        _sessionRepository = sessionRepository ?? MockWorkoutSessionRepository() {
    load();
  }

  final ExerciseRepository _exerciseRepository;
  final WorkoutScheduleRepository _scheduleRepository;
  final WorkoutSessionRepository _sessionRepository;

  DateTime selectedDate = day(DateTime.now());
  bool isLoading = true;
  String? error;
  List<Exercise> library = [];
  List<WorkoutSchedule> schedules = [];
  List<ScheduledExercise> scheduled = [];
  
  WorkoutSession? activeSession;

  Future<void> load() async {
    try {
      library = await _exerciseRepository.getExercises();
      schedules = await _scheduleRepository.getSchedules();
      scheduled = await _scheduleRepository.getScheduledExercises();
      activeSession = await _sessionRepository.getActiveSession();
    } catch (e) {
      error = 'Could not load workout plan.';
    }
    isLoading = false;
    notifyListeners();
  }

  List<ScheduledExercise> get todayExercises =>
      scheduled.where((item) => day(item.date) == selectedDate).toList();

  WorkoutSchedule get selectedSchedule {
    final weekday = selectedDate.weekday; // 1..7
    final found = schedules.where((item) => item.weekday == weekday).cast<WorkoutSchedule?>().firstWhere((item) => item != null, orElse: () => null);
    if (found != null) return found;
    return WorkoutSchedule(weekday: weekday, title: 'Your workout', isRestDay: false);
  }

  Exercise exerciseById(String id) => library.firstWhere((item) => item.id == id);
  
  void addCustomExerciseToLibrary(Exercise exercise) {
    library = [...library, exercise];
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = day(date);
    notifyListeners();
  }

  Future<void> addExercise(
    Exercise exercise, {
    int? sets,
    int? reps,
    int? restSeconds,
    int? targetDurationSeconds,
    String notes = '',
    double? distance,
  }) async {
    final item = ScheduledExercise(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      date: selectedDate,
      exerciseId: exercise.id,
      exerciseType: exercise.type,
      sets: sets,
      reps: reps,
      restSeconds: restSeconds,
      targetDurationSeconds: targetDurationSeconds,
      notes: notes,
      targetDistanceKm: distance,
    );
    await _scheduleRepository.saveScheduledExercise(item);
    scheduled = [...scheduled, item];
    notifyListeners();
  }

  Future<void> updateExercise(ScheduledExercise item) async {
    await _scheduleRepository.saveScheduledExercise(item);
    scheduled = scheduled.map((e) => e.id == item.id ? item : e).toList();
    notifyListeners();
  }

  Future<void> removeExercise(String id) async {
    await _scheduleRepository.deleteScheduledExercise(id);
    scheduled.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> setRestDay(bool value, {String? title}) async {
    final update = selectedSchedule.copyWith(
      isRestDay: value,
      title: value
          ? selectedSchedule.title
          : (title?.trim().isNotEmpty == true
              ? title!.trim()
              : (selectedSchedule.title.trim().isEmpty
                  ? 'Your workout'
                  : selectedSchedule.title)),
    );
    await _scheduleRepository.saveSchedule(update);
    schedules = [...schedules.where((e) => e.weekday != selectedDate.weekday), update];
    notifyListeners();
  }

  Future<void> setScheduleTitle(String title) async {
    final update = selectedSchedule.copyWith(title: title.trim().isEmpty ? 'Your workout' : title.trim());
    await _scheduleRepository.saveSchedule(update);
    schedules = [...schedules.where((e) => e.weekday != selectedDate.weekday), update];
    notifyListeners();
  }

  Future<void> updateWeekdayPlan({
    required int weekday,
    required bool isRestDay,
    required String title,
  }) async {
    final existing = schedules.where((item) => item.weekday == weekday).first;
    final update = existing.copyWith(
      isRestDay: isRestDay,
      title: isRestDay
          ? existing.title
          : (title.trim().isEmpty ? 'Your workout' : title.trim()),
    );
    await _scheduleRepository.saveSchedule(update);
    schedules = [...schedules.where((item) => item.weekday != weekday), update]
      ..sort((a, b) => a.weekday.compareTo(b.weekday));
    notifyListeners();
  }

  Future<void> completeExercise(ScheduledExercise item) => updateExercise(item.copyWith(completed: !item.completed));

  // --- WORKOUT SESSION LOGIC ---

  Future<void> startWorkout() async {
    if (activeSession != null) return;
    final exercises = todayExercises;
    activeSession = WorkoutSession(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      date: DateTime.now(),
      name: selectedSchedule.displayTitle,
      status: WorkoutStatus.IN_PROGRESS,
      startedAt: DateTime.now(),
      exercises: exercises.map((e) => e.copyWith(
        actualSets: e.exerciseType == ExerciseType.STRENGTH || e.exerciseType == ExerciseType.BODYWEIGHT
          ? List.generate(e.sets ?? 0, (i) => WorkoutSet(
              id: '${e.id}-set-$i',
              setNumber: i + 1,
              plannedReps: e.reps,
              status: SetStatus.NOT_STARTED,
            ))
          : const [],
      )).toList(),
    );
    await _sessionRepository.saveSession(activeSession!);
    notifyListeners();
  }

  Future<void> saveActiveSession() async {
    if (activeSession != null) {
      await _sessionRepository.saveSession(activeSession!);
      notifyListeners();
    }
  }

  Future<void> updateActiveExercise(ScheduledExercise exercise) async {
    if (activeSession == null) return;
    final idx = activeSession!.exercises.indexWhere((e) => e.id == exercise.id);
    if (idx >= 0) {
      final newExercises = List<ScheduledExercise>.from(activeSession!.exercises);
      newExercises[idx] = exercise;
      activeSession = activeSession!.copyWith(exercises: newExercises);
      await saveActiveSession();
    }
  }

  Future<void> addExtraSet(String exerciseId) async {
    if (activeSession == null) return;
    final exercise = activeSession!.exercises.firstWhere((e) => e.id == exerciseId);
    final newSet = WorkoutSet(
      id: '${exercise.id}-set-${exercise.actualSets.length}',
      setNumber: exercise.actualSets.length + 1,
      setType: SetType.EXTRA,
      status: SetStatus.NOT_STARTED,
      plannedReps: exercise.reps,
    );
    await updateActiveExercise(exercise.copyWith(actualSets: [...exercise.actualSets, newSet]));
  }

  Future<void> updateWorkoutSet(String exerciseId, WorkoutSet updatedSet) async {
    if (activeSession == null) return;
    final exercise = activeSession!.exercises.firstWhere((e) => e.id == exerciseId);
    final sets = exercise.actualSets.map((s) => s.id == updatedSet.id ? updatedSet : s).toList();
    
    // Check if all sets are completed to auto-complete the exercise
    final allDone = sets.isNotEmpty && sets.every((s) => s.status == SetStatus.COMPLETED || s.status == SetStatus.SKIPPED);
    await updateActiveExercise(exercise.copyWith(actualSets: sets, completed: allDone));
  }

  Future<void> startCardioSegment(String exerciseId) async {
    if (activeSession == null) return;
    final exercise = activeSession!.exercises.firstWhere((e) => e.id == exerciseId);
    await updateActiveExercise(exercise.copyWith(currentSegmentStartedAt: DateTime.now()));
  }

  Future<void> pauseCardioSegment(String exerciseId) async {
    if (activeSession == null) return;
    final exercise = activeSession!.exercises.firstWhere((e) => e.id == exerciseId);
    if (exercise.currentSegmentStartedAt != null) {
      final diff = DateTime.now().difference(exercise.currentSegmentStartedAt!).inSeconds;
      await updateActiveExercise(exercise.copyWith(
        accumulatedDurationSeconds: exercise.accumulatedDurationSeconds + diff,
        clearSegmentStartedAt: true,
      ));
    }
  }

  Future<void> finishCardio(String exerciseId) async {
    if (activeSession == null) return;
    final exercise = activeSession!.exercises.firstWhere((e) => e.id == exerciseId);
    int total = exercise.accumulatedDurationSeconds;
    if (exercise.currentSegmentStartedAt != null) {
      total += DateTime.now().difference(exercise.currentSegmentStartedAt!).inSeconds;
    }
    await updateActiveExercise(exercise.copyWith(
      accumulatedDurationSeconds: total,
      actualDurationSeconds: total,
      completed: true,
      clearSegmentStartedAt: true,
    ));
  }

  Future<void> finishWorkout({bool partiallyCompleted = false}) async {
    if (activeSession == null) return;
    activeSession = activeSession!.copyWith(
      status: partiallyCompleted ? WorkoutStatus.PARTIALLY_COMPLETED : WorkoutStatus.COMPLETED,
      completedAt: DateTime.now(),
      actualDurationMinutes: DateTime.now().difference(activeSession!.startedAt!).inMinutes,
    );
    await _sessionRepository.saveSession(activeSession!);
    activeSession = null;
    notifyListeners();
  }

  Future<void> cancelWorkout() async {
    if (activeSession == null) return;
    activeSession = activeSession!.copyWith(status: WorkoutStatus.CANCELLED);
    await _sessionRepository.saveSession(activeSession!);
    activeSession = null;
    notifyListeners();
  }
}

