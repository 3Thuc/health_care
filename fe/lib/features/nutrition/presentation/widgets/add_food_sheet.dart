import 'package:flutter/material.dart';
import '../../../food/presentation/widgets/manual_entry_sheet.dart';

class AddFoodSheet extends StatelessWidget {
  const AddFoodSheet({super.key, required this.date, required this.meal});

  final DateTime date;
  final String meal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.camera_alt_outlined),
          title: const Text('Take Photo'),
          subtitle: const Text('Use camera to capture your meal (mock)'),
          onTap: () async {
            Navigator.pop(context);
            final result = await Navigator.push<Map<String, dynamic>>(context, MaterialPageRoute(builder: (_) => _MockCameraPreview(meal: meal)));
            if (result != null) Navigator.pop(context, result);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_outlined),
          title: const Text('Choose from Gallery'),
          subtitle: const Text('Select an image from gallery (mock)'),
          onTap: () async {
            Navigator.pop(context);
            final result = await Navigator.push<Map<String, dynamic>>(context, MaterialPageRoute(builder: (_) => _MockGalleryPicker(meal: meal)));
            if (result != null) Navigator.pop(context, result);
          },
        ),
        ListTile(
          leading: const Icon(Icons.search_outlined),
          title: const Text('Search Food'),
          subtitle: const Text('Search from mock database'),
          onTap: () async {
            Navigator.pop(context);
            final result = await showModalBottomSheet<Map<String, dynamic>>(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => _MockSearchSheet(initialMeal: meal));
            if (result != null) Navigator.pop(context, result);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Manual Entry'),
          subtitle: Text('Add custom food to $meal'),
          onTap: () async {
            Navigator.pop(context);
            final result = await showModalBottomSheet<Map<String, dynamic>>(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => ManualEntrySheet(initialMealType: meal, readonlyMealType: true));
            if (result != null) Navigator.pop(context, result);
          },
        ),
        const SizedBox(height: 12),
      ]),
    );
  }
}

class _MockCameraPreview extends StatelessWidget {
  const _MockCameraPreview({required this.meal});
  final String meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera (mock)')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 220, height: 160, color: Theme.of(context).colorScheme.surface, child: const Center(child: Icon(Icons.image, size: 48))),
          const SizedBox(height: 12),
          FilledButton(onPressed: () async {
            // simulate analyzing
            showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pop(context);
            Navigator.pop(context, {'meal': meal, 'name': 'Chicken Sandwich', 'quantity': '1 serving', 'calories': 420, 'protein': 28, 'carbs': 42, 'fat': 14});
          }, child: const Text('Use Photo')),
        ]),
      ),
    );
  }
}

class _MockGalleryPicker extends StatelessWidget {
  const _MockGalleryPicker({required this.meal});
  final String meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery (mock)')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 220, height: 160, color: Theme.of(context).colorScheme.surface, child: const Center(child: Icon(Icons.photo, size: 48))),
          const SizedBox(height: 12),
          FilledButton(onPressed: () async {
            showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pop(context);
            Navigator.pop(context, {'meal': meal, 'name': 'Iced Coffee', 'quantity': '1 cup', 'calories': 180, 'protein': 1, 'carbs': 15, 'fat': 8});
          }, child: const Text('Use Image')),
        ]),
      ),
    );
  }
}

class _MockSearchSheet extends StatefulWidget {
  const _MockSearchSheet({required this.initialMeal});
  final String initialMeal;

  @override
  State<_MockSearchSheet> createState() => _MockSearchSheetState();
}

class _MockSearchSheetState extends State<_MockSearchSheet> {
  final _ctl = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  void _search(String q) {
    final all = [
      {'name': 'Chicken Breast', 'calories': 165, 'protein': 31, 'carbs': 0, 'fat': 4},
      {'name': 'Rice', 'calories': 206, 'protein': 4, 'carbs': 45, 'fat': 0},
      {'name': 'Egg', 'calories': 78, 'protein': 6, 'carbs': 0, 'fat': 5},
      {'name': 'Salmon', 'calories': 233, 'protein': 25, 'carbs': 0, 'fat': 14},
      {'name': 'Banana', 'calories': 105, 'protein': 1, 'carbs': 27, 'fat': 0},
      {'name': 'Milk', 'calories': 122, 'protein': 8, 'carbs': 12, 'fat': 5},
      {'name': 'Greek Yogurt', 'calories': 100, 'protein': 10, 'carbs': 4, 'fat': 0},
      {'name': 'Bread', 'calories': 79, 'protein': 3, 'carbs': 15, 'fat': 1},
      {'name': 'Coffee', 'calories': 2, 'protein': 0, 'carbs': 0, 'fat': 0},
      {'name': 'Protein Shake', 'calories': 220, 'protein': 24, 'carbs': 10, 'fat': 4},
    ];
    setState(() {
      _results = all.where((e) => e['name'].toString().toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: TextField(controller: _ctl, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search food...'), onChanged: _search)),
        const SizedBox(height: 8),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _results.length,
            itemBuilder: (context, i) {
              final r = _results[i];
              return ListTile(
                title: Text(r['name']),
                subtitle: Text('${r['calories']} kcal'),
                onTap: () => Navigator.pop(context, {'meal': widget.initialMeal, 'name': r['name'], 'quantity': '1 serving', 'calories': r['calories'], 'protein': r['protein'], 'carbs': r['carbs'], 'fat': r['fat']}),
              );
            },
          ),
        )
      ]),
    );
  }
}
