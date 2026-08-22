import 'package:flutter/material.dart';

class ManualEntrySheet extends StatefulWidget {
  const ManualEntrySheet({super.key, this.initialMealType, this.readonlyMealType = false});

  final String? initialMealType;
  final bool readonlyMealType;

  @override
  State<ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<ManualEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _qtyCtl = TextEditingController();
  final _calCtl = TextEditingController();
  final _pCtl = TextEditingController();
  final _cCtl = TextEditingController();
  final _fCtl = TextEditingController();
  String _mealType = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _mealType = widget.initialMealType ?? 'Breakfast';
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _qtyCtl.dispose();
    _calCtl.dispose();
    _pCtl.dispose();
    _cCtl.dispose();
    _fCtl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final item = {
      'meal': _mealType,
      'name': _nameCtl.text.trim(),
      'quantity': _qtyCtl.text.trim().isEmpty ? '1' : _qtyCtl.text.trim(),
      'calories': int.tryParse(_calCtl.text.trim()) ?? 0,
      'protein': int.tryParse(_pCtl.text.trim()) ?? 0,
      'carbs': int.tryParse(_cCtl.text.trim()) ?? 0,
      'fat': int.tryParse(_fCtl.text.trim()) ?? 0,
    };
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 20, right: 20, top: 18),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Manual Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'Food name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 8),
              TextFormField(controller: _qtyCtl, decoration: const InputDecoration(labelText: 'Quantity (e.g. 1 cup)'), validator: null),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: TextFormField(controller: _calCtl, decoration: const InputDecoration(labelText: 'Calories (kcal)'), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _pCtl, decoration: const InputDecoration(labelText: 'Protein (g)'), keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: TextFormField(controller: _cCtl, decoration: const InputDecoration(labelText: 'Carbs (g)'), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: _fCtl, decoration: const InputDecoration(labelText: 'Fat (g)'), keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: 8),
              widget.readonlyMealType
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Adding to $_mealType', style: const TextStyle(fontWeight: FontWeight.w600)),
                    )
                  : DropdownButtonFormField<String>(
                      initialValue: _mealType,
                      items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _mealType = v ?? 'Breakfast'),
                      decoration: const InputDecoration(labelText: 'Meal type'),
                    ),
              const SizedBox(height: 12),
              Row(children: [Expanded(child: FilledButton(onPressed: _submit, child: const Text('Add Food')))]),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
