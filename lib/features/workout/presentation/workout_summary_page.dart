import 'package:flutter/material.dart';
import '../models/workout_models.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final WorkoutSession session;

  const WorkoutSummaryPage(this.session, {super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final totalVol = _calculateVolume(session);
    final completedSets = _calculateSets(session);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                  const SizedBox(height: 16),
                  Text(
                    'Workout Complete!',
                    textAlign: TextAlign.center,
                    style: t.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    session.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: t.colorScheme.primary, fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat(label: 'Time', value: '${session.actualDurationMinutes ?? 0}m'),
                      if (totalVol > 0) _Stat(label: 'Volume', value: '${totalVol}kg'),
                      if (completedSets > 0) _Stat(label: 'Sets', value: '$completedSets'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  ...session.exercises.map((e) => _ExerciseSummaryCard(exercise: e)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('Back to Home'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateVolume(WorkoutSession s) {
    double vol = 0;
    for (final e in s.exercises) {
      if (e.exerciseType == ExerciseType.STRENGTH) {
        for (final set in e.actualSets) {
          if (set.status == SetStatus.COMPLETED) {
            vol += (set.actualWeight ?? 0) * (set.actualReps ?? 0);
          }
        }
      }
    }
    return vol.toInt();
  }

  int _calculateSets(WorkoutSession s) {
    int sets = 0;
    for (final e in s.exercises) {
      if (e.exerciseType == ExerciseType.STRENGTH || e.exerciseType == ExerciseType.BODYWEIGHT) {
        sets += e.actualSets.where((set) => set.status == SetStatus.COMPLETED).length;
      }
    }
    return sets;
  }
}

class _ExerciseSummaryCard extends StatelessWidget {
  final ScheduledExercise exercise;
  const _ExerciseSummaryCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isCardio = exercise.exerciseType == ExerciseType.CARDIO;
    final isBodyweight = exercise.exerciseType == ExerciseType.BODYWEIGHT;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exercise.exerciseId, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (isCardio)
            Text('${(exercise.actualDurationSeconds ?? 0) ~/ 60} min / ${(exercise.targetDurationSeconds ?? 0) ~/ 60} min', style: TextStyle(color: t.colorScheme.primary))
          else
            ...exercise.actualSets.where((s) => s.status == SetStatus.COMPLETED).map((s) {
              final w = isBodyweight ? s.additionalWeight : s.actualWeight;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  w != null && w > 0 ? '$w kg × ${s.actualReps} reps' : '${s.actualReps} reps',
                  style: TextStyle(color: t.colorScheme.onSurfaceVariant),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        Text(label, style: TextStyle(color: t.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
