import 'package:flutter/material.dart';
import '../../../core/services/local_storage.dart';

class WorkoutSchedulePage extends StatefulWidget {
  const WorkoutSchedulePage({super.key});

  @override
  State<WorkoutSchedulePage> createState() => _WorkoutSchedulePageState();
}

class _WorkoutSchedulePageState extends State<WorkoutSchedulePage> {
  List<Map<String, dynamic>> _schedules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _schedules = await LocalStorage.instance.readSchedules();
    setState(() => _loading = false);
  }

  Future<void> _addOrEdit([int? index]) async {
    final editing = index != null;
    final existing = editing ? _schedules[index] : null;
    final nameCtl = TextEditingController(text: existing?['name'] ?? '');
    DateTime date = existing != null ? DateTime.parse(existing['date'] as String) : DateTime.now();

    final result = await showModalBottomSheet<bool>(context: context, isScrollControlled: true, builder: (c) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12, left: 16, right: 16, top: 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtl, decoration: const InputDecoration(labelText: 'Workout name')),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Text('Date: ${date.toLocal().toIso8601String().split('T').first}')),
            TextButton(onPressed: () async { final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100)); if (d!=null) setState(() => date = d); }, child: const Text('Pick')),
          ]),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(editing ? 'Save' : 'Add')))]),
          const SizedBox(height: 8),
        ]),
      );
    });

    if (result != true) return;
    final item = {'name': nameCtl.text.trim(), 'date': date.toIso8601String().split('T').first};
    if (editing) {
      _schedules[index] = item;
    } else {
      _schedules.add(item);
    }
    await LocalStorage.instance.saveSchedules(_schedules);
    await _load();
  }

  Future<void> _delete(int index) async {
    final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Delete schedule'), content: const Text('Delete this scheduled workout?'), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete'))]));
    if (ok != true) return;
    _schedules.removeAt(index);
    await LocalStorage.instance.saveSchedules(_schedules);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Schedule')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _schedules.isEmpty
                ? Center(child: Text('No workouts scheduled', style: Theme.of(context).textTheme.bodyLarge))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _schedules.length,
                    itemBuilder: (c, i) {
                      final s = _schedules[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(s['date'] ?? '')])),
                          IconButton(onPressed: () => _addOrEdit(i), icon: const Icon(Icons.edit)),
                          IconButton(onPressed: () => _delete(i), icon: const Icon(Icons.delete)),
                        ]),
                      );
                    }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _addOrEdit(), child: const Icon(Icons.add)),
    );
  }
}
