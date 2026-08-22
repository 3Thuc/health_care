import 'package:flutter/material.dart';

class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _qty;
  late TextEditingController _cal;
  late TextEditingController _p;
  late TextEditingController _c;
  late TextEditingController _f;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.item['name'] ?? '');
    _qty = TextEditingController(text: widget.item['quantity'] ?? '1');
    _cal = TextEditingController(text: (widget.item['calories'] ?? 0).toString());
    _p = TextEditingController(text: (widget.item['protein'] ?? 0).toString());
    _c = TextEditingController(text: (widget.item['carbs'] ?? 0).toString());
    _f = TextEditingController(text: (widget.item['fat'] ?? 0).toString());
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
      // Keep the food in the meal section where the user opened it.
      'meal': widget.item['meal'] ?? 'Breakfast',
      'name': _name.text.trim(),
      'quantity': _qty.text.trim(),
      'calories': int.tryParse(_cal.text.trim()) ?? 0,
      'protein': int.tryParse(_p.text.trim()) ?? 0,
      'carbs': int.tryParse(_c.text.trim()) ?? 0,
      'fat': int.tryParse(_f.text.trim()) ?? 0,
    };
    Navigator.pop(context, {'action': 'update', 'item': updated});
  }

  void _delete() async {
    final confirmed = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Delete food'), content: const Text('Are you sure you want to delete this food?'), actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete'))]));
    if (confirmed == true) Navigator.pop(context, {'action': 'delete'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Detail')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _qty, decoration: const InputDecoration(labelText: 'Quantity')),
                const SizedBox(height: 8),
                Row(children: [Expanded(child: TextFormField(controller: _cal, decoration: const InputDecoration(labelText: 'Calories'), keyboardType: TextInputType.number)), const SizedBox(width: 8), Expanded(child: TextFormField(controller: _p, decoration: const InputDecoration(labelText: 'Protein (g)'), keyboardType: TextInputType.number))]),
                const SizedBox(height: 8),
                Row(children: [Expanded(child: TextFormField(controller: _c, decoration: const InputDecoration(labelText: 'Carbs (g)'), keyboardType: TextInputType.number)), const SizedBox(width: 8), Expanded(child: TextFormField(controller: _f, decoration: const InputDecoration(labelText: 'Fat (g)'), keyboardType: TextInputType.number))]),
                const SizedBox(height: 16),
                Row(children: [Expanded(child: FilledButton(onPressed: _save, child: const Text('Save'))), const SizedBox(width: 8), OutlinedButton(onPressed: _delete, child: const Text('Delete'))]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
