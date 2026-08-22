import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../models/workout_models.dart';
import 'providers/workout_provider.dart';
import 'workout_session_page.dart';
import 'edit_week_page.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<WorkoutProvider>(
    builder: (context, state, _) {
      if (state.isLoading)
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      if (state.error != null)
        return Scaffold(body: Center(child: Text(state.error!)));
      final theme = Theme.of(context);
      final today = DateTime.now();
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workout! ',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Ready to conquer today?',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: .65,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.fitness_center_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _DateSelector(),
              const SizedBox(height: 18),
              _TodayWorkout(today: today),
              const SizedBox(height: 26),
              _LibraryPreview(),
            ],
          ),
        ),
      );
    },
  );
}

class _DateSelector extends StatelessWidget {
  const _DateSelector();
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkoutProvider>();
    final date = state.selectedDate;
    final schedule = state.selectedSchedule;
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final dayLabel = isToday
        ? 'TODAY (${DateFormat.E().format(date).toUpperCase()})'
        : DateFormat.EEEE().format(date).toUpperCase();
    final String workoutTitle =
        '${schedule.displayTitle.toUpperCase()}${schedule.isRestDay ? ' DAY' : ' DAY'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B39BC), Color(0xFF08194F)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B39BC).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left chevron button
          InkWell(
            onTap: () =>
                state.selectDate(date.subtract(const Duration(days: 1))),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Middle date pick button
          Expanded(
            child: InkWell(
              onTap: () => _pickWorkoutDate(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$dayLabel - $workoutTitle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Right chevron button
          InkWell(
            onTap: () => state.selectDate(date.add(const Duration(days: 1))),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Full Week button
          InkWell(
            onTap: () => _openFullWeek(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Full Week',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _pickWorkoutDate(BuildContext context) async {
  final state = context.read<WorkoutProvider>();
  final date = await showDatePicker(
    context: context,
    initialDate: state.selectedDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
  );
  if (date != null) state.selectDate(date);
}

void _openFullWeek(BuildContext context) {
  final state = context.read<WorkoutProvider>();
  final monday = state.selectedDate.subtract(
    Duration(days: state.selectedDate.weekday - 1),
  );
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheet) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'This Week',
                  style: Theme.of(
                    sheet,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(sheet);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditWeekPage()),
                    );
                  },
                  icon: const Icon(Icons.edit_calendar_outlined),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(7, (i) {
              final d = monday.add(Duration(days: i));
              final plan = state.schedules.firstWhere(
                (x) => x.weekday == d.weekday,
              );
              final selected = DateUtils.isSameDay(d, state.selectedDate);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                selected: selected,
                leading: SizedBox(
                  width: 42,
                  child: Text(
                    DateFormat.E().format(d).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                title: Text(
                  plan.displayTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: selected ? const Icon(Icons.check_circle) : null,
                onTap: () {
                  state.selectDate(d);
                  Navigator.pop(sheet);
                },
              );
            }),
          ],
        ),
      ),
    ),
  );
}

class _TodayWorkout extends StatelessWidget {
  const _TodayWorkout({required this.today});
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkoutProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final schedule = state.selectedSchedule;
    final items = state.todayExercises;
    final isToday = DateUtils.isSameDay(today, state.selectedDate);
    final complete = items.where((e) => e.completed).length;
    final done = items.isNotEmpty && complete == items.length;

    void startSession() async {
      await state.startWorkout();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const WorkoutSessionPage(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Workout",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat.EEEE().format(state.selectedDate)} • ${schedule.displayTitle}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: .65),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _addSheet(context),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text(
                'Add Exercise',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0C1425) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!schedule.isRestDay) ...[
                _Progress(
                  completed: complete,
                  total: items.length,
                  isToday: isToday,
                ),
                const SizedBox(height: 16),
              ],
              if (schedule.isRestDay)
                _RestDay(onSet: () => state.setRestDay(false))
              else if (items.isEmpty)
                _EmptyDay(onAdd: () => _addSheet(context))
              else ...[
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ScheduledCard(item: item),
                  ),
                ),
                // Start Workout button placed at the bottom of the list
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: startSession,
                      borderRadius: BorderRadius.circular(14),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: done ? null : AppGradients.primaryGradient,
                          color: done ? const Color(0xFF10B981) : null,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color: (done ? const Color(0xFF10B981) : const Color(0xFF3B82F6))
                                        .withValues(alpha: 0.25),
                                    blurRadius: 16,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              done ? Icons.check_circle_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              done ? 'Workout Complete' : 'Start Workout',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({
    required this.completed,
    required this.total,
    required this.isToday,
  });
  final int completed, total;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1A2E) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Row(
        children: [
          // Circular progress on the left
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4.5,
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  color: t.colorScheme.primary,
                ),
                Text(
                  '$completed/$total',
                  style: TextStyle(
                    color: t.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Middle/Right details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$completed of $total exercises completed',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.05),
                          color: t.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: t.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.onAdd});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.event_available_rounded, color: t.colorScheme.primary),
          const SizedBox(height: 10),
          const Text(
            'No exercises scheduled for this day.',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            'Build a focused plan from the exercise library.',
            style: TextStyle(
              color: t.colorScheme.onSurface.withValues(alpha: .65),
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Exercise'),
          ),
        ],
      ),
    );
  }
}

class _RestDay extends StatelessWidget {
  const _RestDay({required this.onSet});
  final VoidCallback onSet;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.self_improvement_rounded, color: t.colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            'Rest Day',
            style: t.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "You don't have a workout scheduled today.",
            style: TextStyle(
              color: t.colorScheme.onSurface.withValues(alpha: .65),
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(onPressed: onSet, child: const Text('Set Workout')),
        ],
      ),
    );
  }
}

class _ScheduledCard extends StatelessWidget {
  const _ScheduledCard({required this.item});
  final ScheduledExercise item;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<WorkoutProvider>();
    final ex = s.exerciseById(item.exerciseId);
    final t = Theme.of(context);

    final isDark = t.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(t.brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.primaryBlue.withValues(alpha: 0.08)
              : t.colorScheme.outline.withValues(alpha: .08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  t.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.12),
                  AppColors.primaryViolet.withValues(
                    alpha: isDark ? 0.1 : 0.05,
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: t.colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: Text(ex.icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ex.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  ex.targetMuscle,
                  style: TextStyle(
                    color: t.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  item.exerciseType == ExerciseType.CARDIO
                      ? 'Target: ${(item.targetDurationSeconds ?? 0) ~/ 60} min'
                      : '${item.sets ?? 0} sets × ${item.reps ?? 0} reps  •  Rest ${item.restSeconds ?? 0}s',
                  style: TextStyle(
                    color: t.colorScheme.onSurface.withValues(alpha: .65),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _configure(context, ex, item);
              } else {
                _remove(context, item);
              }
            },
            itemBuilder: (menuContext) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}

class _LibraryPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.watch<WorkoutProvider>();
    final t = Theme.of(context);
    final exercises = s.library.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Exercise Library',
                style: t.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _librarySheet(context),
              child: const Text('View all'),
            ),
          ],
        ),
        Text(
          'Discover movements for your next session.',
          style: TextStyle(
            color: t.colorScheme.onSurface.withValues(alpha: .65),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: exercises.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final e = exercises[i];
              return InkWell(
                onTap: () => _detailSheet(context, e),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 145,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: AppGradients.cardGradient(t.brightness),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: t.brightness == Brightness.dark
                          ? AppColors.primaryBlue.withValues(alpha: 0.08)
                          : t.colorScheme.outline.withValues(alpha: .08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.icon, style: const TextStyle(fontSize: 22)),
                      const Spacer(),
                      Text(
                        e.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        e.targetMuscle,
                        style: TextStyle(
                          fontSize: 12,
                          color: t.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

void _addSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  builder: (sheet) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Add Exercise',
          style: Theme.of(
            sheet,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.menu_book_rounded),
          title: const Text('Choose from Exercise Library'),
          subtitle: const Text('Browse and configure an exercise'),
          onTap: () {
            Navigator.pop(sheet);
            _librarySheet(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit_note_rounded),
          title: const Text('Create Custom Exercise'),
          subtitle: const Text('Add a personal exercise to today\'s plan'),
          onTap: () {
            Navigator.pop(sheet);
            _customSheet(context);
          },
        ),
      ],
    ),
  ),
);
void _librarySheet(BuildContext context) {
  String query = '';
  String muscle = 'All', difficulty = 'All', equipment = 'All';

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, setSheet) {
        final s = context.read<WorkoutProvider>();
        final list = s.library
            .where(
              (e) =>
                  (query.isEmpty ||
                      '${e.name} ${e.targetMuscle}'.toLowerCase().contains(
                        query.toLowerCase(),
                      )) &&
                  (muscle == 'All' || e.targetMuscle == muscle) &&
                  (difficulty == 'All' || e.difficulty == difficulty) &&
                  (equipment == 'All' || e.equipment == equipment),
            )
            .toList();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
            child: Column(
              children: [
                Text(
                  'Exercise Library',
                  style: Theme.of(
                    sheet,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) => setSheet(() => query = v),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search exercises...',
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filter(sheet, 'Muscle', muscle, [
                        'All',
                        'Chest',
                        'Back',
                        'Shoulders',
                        'Arms',
                        'Legs',
                        'Core',
                        'Cardio',
                      ], (v) => setSheet(() => muscle = v)),
                      _filter(
                        sheet,
                        'Level',
                        difficulty,
                        ['All', 'Beginner', 'Intermediate', 'Advanced'],
                        (v) => setSheet(() => difficulty = v),
                      ),
                      _filter(
                        sheet,
                        'Equipment',
                        equipment,
                        [
                          'All',
                          'Bodyweight',
                          'Dumbbell',
                          'Barbell',
                          'Machine',
                          'Cable',
                        ],
                        (v) => setSheet(() => equipment = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (listContext, i) {
                      final e = list[i];
                      return Card(
                        child: ListTile(
                          leading: Text(
                            e.icon,
                            style: const TextStyle(fontSize: 25),
                          ),
                          title: Text(e.name),
                          subtitle: Text(
                            '${e.targetMuscle} • ${e.difficulty} • ${e.equipment}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pop(sheet);
                            _detailSheet(context, e);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _filter(
  BuildContext context,
  String label,
  String value,
  List<String> options,
  ValueChanged<String> change,
) => Padding(
  padding: const EdgeInsets.only(right: 8),
  child: DropdownButton<String>(
    value: value,
    underline: const SizedBox(),
    items: options
        .map(
          (x) =>
              DropdownMenuItem(value: x, child: Text(x == 'All' ? label : x)),
        )
        .toList(),
    onChanged: (x) {
      if (x != null) {
        change(x);
      }
    },
  ),
);
void _detailSheet(BuildContext context, Exercise e) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .78,
      builder: (sheetContext, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Center(child: Text(e.icon, style: const TextStyle(fontSize: 56))),
          Text(
            e.name,
            style: Theme.of(
              sheet,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text('${e.targetMuscle} • ${e.difficulty} • ${e.equipment}'),
          const SizedBox(height: 18),
          Text(e.description),
          if (e.instructions.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'How to perform',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            ...e.instructions.map(
              (x) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('• $x'),
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.pop(sheet);
              if (!context.mounted) return;
              _configure(context, e, null);
            },
            child: Text(
              'Add to ${DateFormat.EEEE().format(context.read<WorkoutProvider>().selectedDate)}',
            ),
          ),
        ],
      ),
    ),
  );
}

void _configure(BuildContext context, Exercise e, ScheduledExercise? existing) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) => _ConfigureSheet(e: e, existing: existing),
  );
}

class _ConfigureSheet extends StatefulWidget {
  final Exercise e;
  final ScheduledExercise? existing;
  const _ConfigureSheet({required this.e, this.existing});

  @override
  State<_ConfigureSheet> createState() => _ConfigureSheetState();
}

class _ConfigureSheetState extends State<_ConfigureSheet> {
  late final TextEditingController sets;
  late final TextEditingController reps;
  late final TextEditingController rest;
  late final TextEditingController duration;
  late final TextEditingController distance;
  late final TextEditingController notes;

  String? errorText;

  @override
  void initState() {
    super.initState();
    sets = TextEditingController(text: '${widget.existing?.sets ?? 3}');
    reps = TextEditingController(text: '${widget.existing?.reps ?? 10}');
    rest = TextEditingController(text: '${widget.existing?.restSeconds ?? 90}');
    duration = TextEditingController(text: '${(widget.existing?.targetDurationSeconds ?? 1800) ~/ 60}');
    notes = TextEditingController(text: widget.existing?.notes ?? '');
  }

  @override
  void dispose() {
    sets.dispose();
    reps.dispose();
    rest.dispose();
    duration.dispose();
    notes.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => errorText = null);
    
    final isCardio = widget.e.type == ExerciseType.CARDIO;
    final isStrength = widget.e.type == ExerciseType.STRENGTH;
    final isBodyweight = widget.e.type == ExerciseType.BODYWEIGHT;
    
    int? s, r, rt, durSec;

    if (isCardio) {
      final durMin = int.tryParse(duration.text);
      if (durMin == null || durMin < 1) { setState(() => errorText = 'Target duration must be at least 1 minute'); return; }
      durSec = durMin * 60;
    } else {
      s = int.tryParse(sets.text);
      r = int.tryParse(reps.text);
      rt = int.tryParse(rest.text);
      if (s == null || s < 1) { setState(() => errorText = 'Sets must be at least 1'); return; }
      if (r == null || r < 1) { setState(() => errorText = 'Target Reps must be at least 1'); return; }
      if (rt == null || rt < 0) { setState(() => errorText = 'Rest cannot be negative'); return; }
    }

    final provider = context.read<WorkoutProvider>();
    if (widget.existing == null) {
      provider.addExercise(
        widget.e,
        sets: s,
        reps: r,
        restSeconds: rt,
        targetDurationSeconds: durSec,
        notes: notes.text,
      );
    } else {
      provider.updateExercise(
        widget.existing!.copyWith(
          sets: s,
          reps: r,
          restSeconds: rt,
          targetDurationSeconds: durSec,
          notes: notes.text,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isCardio = widget.e.type == ExerciseType.CARDIO;
    final isStrengthOrBodyweight = widget.e.type == ExerciseType.STRENGTH || widget.e.type == ExerciseType.BODYWEIGHT;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing == null ? 'Configure Exercise' : 'Edit Exercise',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(widget.e.name),
            const SizedBox(height: 12),
            if (isCardio) ...[
              _field(duration, 'Target Duration (min)'),
            ] else if (isStrengthOrBodyweight) ...[
              Row(
                children: [
                  Expanded(child: _field(sets, 'Sets')),
                  const SizedBox(width: 10),
                  Expanded(child: _field(reps, 'Target Reps')),
                ],
              ),
              const SizedBox(height: 12),
              _field(rest, 'Rest (sec)'),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: notes,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            if (errorText != null) ...[
              const SizedBox(height: 10),
              Text(errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _save,
              child: Text(
                widget.existing == null
                    ? 'Add to ${DateFormat.EEEE().format(context.read<WorkoutProvider>().selectedDate)}'
                    : 'Save changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _field(TextEditingController c, String label, {bool isDecimal = false}) => TextField(
      controller: c,
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      decoration: InputDecoration(labelText: label),
    );

void _remove(BuildContext context, ScheduledExercise item) async {
  final provider = context.read<WorkoutProvider>();
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Remove exercise?'),
      content: const Text("Remove this exercise from today's workout?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Remove'),
        ),
      ],
    ),
  );

  if (ok == true) {
    provider.removeExercise(item.id);
  }
}

void _customSheet(BuildContext context) {
  final name = TextEditingController();
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Exercise name'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty) {
                return;
              }

              final exercise = Exercise(
                id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
                name: name.text.trim(),
                description: 'Custom exercise',
                targetMuscle: 'Custom',
                difficulty: 'Custom',
                equipment: 'Custom',
                icon: '✨',
              );

              context.read<WorkoutProvider>().addCustomExerciseToLibrary(
                exercise,
              );
              Navigator.pop(sheet);
              _configure(context, exercise, null);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    ),
  );
}
