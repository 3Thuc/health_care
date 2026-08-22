import 'package:flutter/material.dart';

class AddFoodSheet extends StatelessWidget {
  const AddFoodSheet({super.key, required this.onOptionSelected});

  final ValueChanged<String> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final options = [
      _OptionData('Take Photo', Icons.camera_alt_outlined, 'Scan meal from camera'),
      _OptionData('Choose From Gallery', Icons.photo_library_outlined, 'Pick an image from gallery'),
      _OptionData('Search Food', Icons.search_outlined, 'Browse common foods'),
      _OptionData('Enter Manually', Icons.edit_note_outlined, 'Add calories by hand'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Add Food', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          ...options.map((option) => InkWell(
                    onTap: () {
                      onOptionSelected(option.title);
                    },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
                        child: Icon(option.icon, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(option.subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha((0.65 * 255).round()))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _OptionData {
  const _OptionData(this.title, this.icon, this.subtitle);

  final String title;
  final IconData icon;
  final String subtitle;
}
