import 'package:flutter/material.dart';

class EditFoodSheet extends StatefulWidget {
  const EditFoodSheet({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  State<EditFoodSheet> createState() => _EditFoodSheetState();
}

class _EditFoodSheetState extends State<EditFoodSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _qty;
  late TextEditingController _cal;
  late TextEditingController _p;
  late TextEditingController _c;
  late TextEditingController _f;
  late String _meal;

  @override
  void initState() {
    super.initState();
    final it = widget.item;
    _name = TextEditingController(text: it['name'] ?? '');
    _qty = TextEditingController(text: it['quantity']?.toString() ?? '1');
    _cal = TextEditingController(text: (it['calories'] ?? 0).toString());
    _p = TextEditingController(text: (it['protein'] ?? 0).toString());
    _c = TextEditingController(text: (it['carbs'] ?? 0).toString());
    _f = TextEditingController(text: (it['fat'] ?? 0).toString());
    _meal = it['meal'] ?? 'Breakfast';
  }

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    _cal.dispose();
    _p.dispose();
    _c.dispose();
    _f.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final updated = {
      'meal': _meal,
      'name': _name.text.trim(),
      'quantity': _qty.text.trim(),
      'calories': int.tryParse(_cal.text.trim()) ?? 0,
      'protein': int.tryParse(_p.text.trim()) ?? 0,
      'carbs': int.tryParse(_c.text.trim()) ?? 0,
      'fat': int.tryParse(_f.text.trim()) ?? 0,
    };
    Navigator.pop(context, {'action': 'update', 'item': updated});
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Delete food'), content: const Text('Are you sure you want to delete this food?'), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete'))]));
    if (confirmed == true) Navigator.pop(context, {'action': 'delete'});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit Food', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _qty, decoration: const InputDecoration(labelText: 'Quantity')),
                const SizedBox(height: 8),
                Row(children: [Expanded(child: TextFormField(controller: _cal, decoration: const InputDecoration(labelText: 'Calories'), keyboardType: TextInputType.number)), const SizedBox(width: 8), Expanded(child: TextFormField(controller: _p, decoration: const InputDecoration(labelText: 'Protein (g)'), keyboardType: TextInputType.number))]),
                const SizedBox(height: 8),
                Row(children: [Expanded(child: TextFormField(controller: _c, decoration: const InputDecoration(labelText: 'Carbs (g)'), keyboardType: TextInputType.number)), const SizedBox(width: 8), Expanded(child: TextFormField(controller: _f, decoration: const InputDecoration(labelText: 'Fat (g)'), keyboardType: TextInputType.number))]),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(initialValue: _meal, items: ['Breakfast', 'Lunch', 'Dinner', 'Extras'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _meal = v ?? _meal), decoration: const InputDecoration(labelText: 'Meal')),
                const SizedBox(height: 16),
                Row(children: [Expanded(child: FilledButton(onPressed: _save, child: const Text('Save'))), const SizedBox(width: 8), OutlinedButton(onPressed: _delete, child: const Text('Delete'))]),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
