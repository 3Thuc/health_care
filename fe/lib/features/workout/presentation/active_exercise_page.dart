import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../models/workout_models.dart';
import 'providers/workout_provider.dart';

class ActiveExercisePage extends StatefulWidget {
  final ScheduledExercise exercise;

  const ActiveExercisePage({super.key, required this.exercise});

  @override
  State<ActiveExercisePage> createState() => _ActiveExercisePageState();
}

class _ActiveExercisePageState extends State<ActiveExercisePage> {
  Timer? _restTimer;
  int _rest = 0;

  void _startRest(int seconds) {
    _restTimer?.cancel();
    setState(() => _rest = seconds);
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (--_rest <= 0) {
          _rest = 0;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final provider = context.watch<WorkoutProvider>();
    final session = provider.activeSession;
    
    if (session == null) {
      return const Scaffold(body: Center(child: Text('No active session')));
    }

    final currentExercise = session.exercises.firstWhere(
      (e) => e.id == widget.exercise.id,
      orElse: () => widget.exercise,
    );
    final exDef = provider.exerciseById(currentExercise.exerciseId);

    return Scaffold(
      appBar: AppBar(
        title: Text('${exDef.icon} ${exDef.name}'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(exDef.name, style: t.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                  Text('${exDef.targetMuscle} • ${exDef.type.name}', style: TextStyle(color: t.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: currentExercise.exerciseType == ExerciseType.CARDIO
                        ? _CardioActiveView(exercise: currentExercise, provider: provider)
                        : _SetsActiveView(
                            exercise: currentExercise,
                            provider: provider,
                            onSetCompleted: _startRest,
                          ),
                  ),
                ],
              ),
            ),
            if (_rest > 0)
              Positioned(
                bottom: 80,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: t.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer, color: t.colorScheme.onPrimaryContainer),
                            const SizedBox(width: 10),
                            Text('Rest Timer', style: TextStyle(color: t.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('$_rest s', style: TextStyle(color: t.colorScheme.onPrimaryContainer, fontSize: 18, fontWeight: FontWeight.w900)),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: () {
                                _restTimer?.cancel();
                                setState(() => _rest = 0);
                              },
                              child: Text('Skip Rest', style: TextStyle(color: t.colorScheme.onPrimaryContainer)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// CARDIO VIEW
// ---------------------------------------------------------
class _CardioActiveView extends StatefulWidget {
  final ScheduledExercise exercise;
  final WorkoutProvider provider;

  const _CardioActiveView({required this.exercise, required this.provider});

  @override
  State<_CardioActiveView> createState() => _CardioActiveViewState();
}

class _CardioActiveViewState extends State<_CardioActiveView> {
  Timer? _ticker;
  int _currentSeconds = 0;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.exercise.currentSegmentStartedAt != null) {
        setState(() {
          _currentSeconds = DateTime.now().difference(widget.exercise.currentSegmentStartedAt!).inSeconds;
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _time(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isRunning = widget.exercise.currentSegmentStartedAt != null;
    final totalElapsed = widget.exercise.accumulatedDurationSeconds + (isRunning ? _currentSeconds : 0);
    final target = widget.exercise.targetDurationSeconds ?? 0;

    return Column(
      children: [
        const SizedBox(height: 40),
        Text('TARGET', style: TextStyle(color: t.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
        Text('${target ~/ 60} min', style: t.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
        const Spacer(),
        Text('ELAPSED', style: TextStyle(color: t.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
        Text(_time(totalElapsed), style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: t.colorScheme.primary)),
        const Spacer(),
        if (isRunning) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => widget.provider.pauseCardioSegment(widget.exercise.id),
                  child: const Text('Pause'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    await widget.provider.finishCardio(widget.exercise.id);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Finish Cardio'),
                ),
              ),
            ],
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => widget.provider.startCardioSegment(widget.exercise.id),
              child: Text(totalElapsed > 0 ? 'Resume' : 'Start'),
            ),
          ),
          if (totalElapsed > 0) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  await widget.provider.finishCardio(widget.exercise.id);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Finish Cardio'),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

// ---------------------------------------------------------
// STRENGTH & BODYWEIGHT VIEW
// ---------------------------------------------------------
class _SetsActiveView extends StatefulWidget {
  final ScheduledExercise exercise;
  final WorkoutProvider provider;
  final ValueChanged<int> onSetCompleted;

  const _SetsActiveView({required this.exercise, required this.provider, required this.onSetCompleted});

  @override
  State<_SetsActiveView> createState() => _SetsActiveViewState();
}

class _SetsActiveViewState extends State<_SetsActiveView> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    
    // Find the active set
    final activeSetIndex = widget.exercise.actualSets.indexWhere((s) => s.status == SetStatus.NOT_STARTED || s.status == SetStatus.IN_PROGRESS);
    
    if (activeSetIndex == -1) {
      // All sets completed
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          Text('All Sets Completed', style: t.textTheme.titleLarge),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Return to Overview'),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => widget.provider.addExtraSet(widget.exercise.id),
            child: const Text('Add Extra Set'),
          ),
        ],
      );
    }

    final activeSet = widget.exercise.actualSets[activeSetIndex];
    final isBodyweight = widget.exercise.exerciseType == ExerciseType.BODYWEIGHT;
    
    // Previous set data for prefill
    WorkoutSet? prevSet;
    if (activeSetIndex > 0) {
      prevSet = widget.exercise.actualSets[activeSetIndex - 1];
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: t.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SET ${activeSetIndex + 1} / ${widget.exercise.sets ?? 0}', style: const TextStyle(fontWeight: FontWeight.w900)),
              if (prevSet != null)
                Text(
                  'Previous: ${prevSet.actualWeight != null && !isBodyweight ? '${prevSet.actualWeight}kg × ' : ''}${prevSet.actualReps} reps',
                  style: TextStyle(color: t.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: _ActiveSetInput(
            key: ValueKey(activeSet.id), // Force rebuild on new set
            workoutSet: activeSet,
            exercise: widget.exercise,
            provider: widget.provider,
            prevSet: prevSet,
            isBodyweight: isBodyweight,
            onSetCompleted: widget.onSetCompleted,
          ),
        ),
      ],
    );
  }
}

class _ActiveSetInput extends StatefulWidget {
  final WorkoutSet workoutSet;
  final ScheduledExercise exercise;
  final WorkoutProvider provider;
  final WorkoutSet? prevSet;
  final bool isBodyweight;
  final ValueChanged<int> onSetCompleted;

  const _ActiveSetInput({
    super.key,
    required this.workoutSet,
    required this.exercise,
    required this.provider,
    required this.prevSet,
    required this.isBodyweight,
    required this.onSetCompleted,
  });

  @override
  State<_ActiveSetInput> createState() => _ActiveSetInputState();
}

class _ActiveSetInputState extends State<_ActiveSetInput> {
  late final TextEditingController _reps;
  late final TextEditingController _weight; // Used for actualWeight in STRENGTH, additionalWeight in BODYWEIGHT

  @override
  void initState() {
    super.initState();
    
    // Prefill logic
    String repsPrefill = widget.workoutSet.plannedReps?.toString() ?? '10';
    if (widget.prevSet?.actualReps != null) {
      repsPrefill = widget.prevSet!.actualReps!.toString();
    }
    
    String weightPrefill = widget.workoutSet.plannedWeight?.toString() ?? '';
    if (widget.isBodyweight) {
      if (widget.prevSet?.additionalWeight != null) {
        weightPrefill = widget.prevSet!.additionalWeight!.toString();
      }
    } else {
      if (widget.prevSet?.actualWeight != null) {
        weightPrefill = widget.prevSet!.actualWeight!.toString();
      } else {
        weightPrefill = '0.0';
      }
    }

    _reps = TextEditingController(text: repsPrefill);
    _weight = TextEditingController(text: weightPrefill);
  }

  @override
  void dispose() {
    _reps.dispose();
    _weight.dispose();
    super.dispose();
  }

  Future<void> _completeSet() async {
    final reps = int.tryParse(_reps.text) ?? widget.workoutSet.plannedReps;
    final w = double.tryParse(_weight.text);
    
    final updated = widget.workoutSet.copyWith(
      status: SetStatus.COMPLETED,
      actualReps: reps,
      actualWeight: widget.isBodyweight ? null : w,
      additionalWeight: widget.isBodyweight ? w : null,
      completedAt: DateTime.now(),
    );
    
    await widget.provider.updateWorkoutSet(widget.exercise.id, updated);
    widget.onSetCompleted(widget.exercise.restSeconds ?? 0);
  }

  Future<void> _skipSet() async {
    final updated = widget.workoutSet.copyWith(
      status: SetStatus.SKIPPED,
      actualReps: null,
      actualWeight: null,
      additionalWeight: null,
      completedAt: DateTime.now(),
    );
    await widget.provider.updateWorkoutSet(widget.exercise.id, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.isBodyweight) ...[
          _BigInputRow(label: 'Weight (kg)', controller: _weight, isDecimal: true),
          const SizedBox(height: 20),
        ],
        _BigInputRow(label: 'Reps', controller: _reps, isDecimal: false),
        if (widget.isBodyweight) ...[
          const SizedBox(height: 20),
          _BigInputRow(label: 'Additional Weight (kg, optional)', controller: _weight, isDecimal: true),
        ],
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: _completeSet,
            child: const Text('✓ Complete Set', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: _skipSet,
            child: const Text('Skip Set'),
          ),
        ),
      ],
    );
  }
}

class _BigInputRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDecimal;

  const _BigInputRow({required this.label, required this.controller, required this.isDecimal});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () {
                final v = (double.tryParse(controller.text) ?? 0) - (isDecimal ? 2.5 : 1);
                controller.text = (v < 0 ? 0 : v).toStringAsFixed(isDecimal ? 1 : 0);
              },
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: true,
                  fillColor: t.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: () {
                final v = (double.tryParse(controller.text) ?? 0) + (isDecimal ? 2.5 : 1);
                controller.text = v.toStringAsFixed(isDecimal ? 1 : 0);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        )
      ],
    );
  }
}
