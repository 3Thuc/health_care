import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../models/workout_models.dart';
import 'providers/workout_provider.dart';
import 'workout_summary_page.dart';
import 'active_exercise_page.dart';

class WorkoutSessionPage extends StatefulWidget {
  const WorkoutSessionPage({super.key});
  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  Timer? _ticker;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _confirmLeave() async {
    if (_isLeaving) return;
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Leave workout?'),
        content: const Text('Your session is saved. You can resume it later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep training'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      setState(() => _isLeaving = true);
      Navigator.pop(context);
    }
  }

  String _time(Duration d) => '${d.inHours > 0 ? '${d.inHours}:' : ''}${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final provider = context.watch<WorkoutProvider>();
    final session = provider.activeSession;
    
    if (session == null) {
      return const Scaffold(body: Center(child: Text('No active session')));
    }

    final duration = DateTime.now().difference(session.startedAt ?? DateTime.now());

    int completedEx = session.exercises.where((e) => e.completed).length;

    return PopScope(
      canPop: _isLeaving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(session.name),
          leading: IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
            onPressed: _confirmLeave,
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(_time(duration), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Text('$completedEx / ${session.exercises.length} exercises completed', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: session.exercises.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 20),
                  itemBuilder: (c, i) => _ExerciseOverviewCard(
                    exercise: session.exercises[i],
                    provider: provider,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(16),
          color: t.colorScheme.surface,
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    final finishedSession = provider.activeSession;
                    await provider.finishWorkout(partiallyCompleted: completedEx < session.exercises.length);
                    if (context.mounted && finishedSession != null) {
                      _isLeaving = true;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => WorkoutSummaryPage(finishedSession)),
                      );
                    }
                  },
                  child: const Text('Finish Workout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseOverviewCard extends StatelessWidget {
  final ScheduledExercise exercise;
  final WorkoutProvider provider;

  const _ExerciseOverviewCard({
    required this.exercise,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final exDef = provider.exerciseById(exercise.exerciseId);
    final isCardio = exercise.exerciseType == ExerciseType.CARDIO;
    
    // Status text logic
    String statusText = '';
    if (isCardio) {
      if (exercise.completed) {
        statusText = 'Completed';
      } else {
        int elapsed = exercise.accumulatedDurationSeconds;
        if (exercise.currentSegmentStartedAt != null) {
          elapsed += DateTime.now().difference(exercise.currentSegmentStartedAt!).inSeconds;
        }
        if (elapsed > 0) {
          statusText = '${elapsed ~/ 60} min elapsed';
        } else {
          statusText = 'Not started';
        }
      }
    } else {
      int completedSets = exercise.actualSets.where((s) => s.status == SetStatus.COMPLETED).length;
      int extraSets = exercise.actualSets.where((s) => s.setType == SetType.EXTRA && s.status == SetStatus.COMPLETED).length;
      int plannedCompleted = completedSets - extraSets;
      
      if (exercise.completed) {
        statusText = 'Completed';
      } else {
        statusText = '$plannedCompleted / ${exercise.sets ?? 0} planned sets';
        if (extraSets > 0) {
          statusText += ' + $extraSets extra';
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: exercise.completed ? t.colorScheme.primaryContainer.withValues(alpha: .3) : t.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (exercise.completed) ...[
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                const SizedBox(width: 12),
              ] else ...[
                Text(exDef.icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exDef.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('${exDef.targetMuscle} • ${exDef.type.name}', style: TextStyle(color: t.colorScheme.onSurfaceVariant, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(statusText, style: TextStyle(color: exercise.completed ? t.colorScheme.primary : t.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
              if (!exercise.completed)
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ActiveExercisePage(exercise: exercise)));
                  },
                  child: Text(exercise.actualSets.isNotEmpty && exercise.actualSets.any((s) => s.status != SetStatus.NOT_STARTED) ? 'Continue' : 'Start'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
