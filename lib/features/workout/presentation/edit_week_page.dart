import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/workout_models.dart';
import 'providers/workout_provider.dart';

class EditWeekPage extends StatelessWidget {
  const EditWeekPage({super.key});

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Week')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          itemCount: 7,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final schedule = provider.schedules.firstWhere(
              (item) => item.weekday == index + 1,
            );
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: .08)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 78,
                    child: Text(_days[index], style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: .65), fontSize: 13)),
                  ),
                  Expanded(
                    child: Text(
                      schedule.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: schedule.isRestDay ? theme.colorScheme.onSurface.withValues(alpha: .62) : null,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit ${_days[index]}',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _openDayEditor(context, schedule, _days[index]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _openDayEditor(BuildContext context, WorkoutSchedule schedule, String weekdayLabel) async {
  final title = TextEditingController(text: schedule.title);
  var isRestDay = schedule.isRestDay;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setModalState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit $weekdayLabel', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Workout Day'), icon: Icon(Icons.fitness_center_outlined)),
                ButtonSegment(value: true, label: Text('Rest Day'), icon: Icon(Icons.self_improvement_outlined)),
              ],
              selected: {isRestDay},
              onSelectionChanged: (selection) => setModalState(() => isRestDay = selection.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: title,
              enabled: !isRestDay,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Workout Name', hintText: 'e.g. Upper Body'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      if (!isRestDay && title.text.trim().isEmpty) return;
                      await context.read<WorkoutProvider>().updateWeekdayPlan(
                            weekday: schedule.weekday,
                            isRestDay: isRestDay,
                            title: title.text,
                          );
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  title.dispose();
}
