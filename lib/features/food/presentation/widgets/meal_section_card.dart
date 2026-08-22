import 'package:flutter/material.dart';

class FoodItem {
  const FoodItem({
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final String name;
  final String quantity;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
}

class MealSectionCard extends StatelessWidget {
  const MealSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.onAddFood,
    this.onItemTap,
  });

  final String title;
  final IconData icon;
  final List<FoodItem> items;
  final VoidCallback onAddFood;
  final void Function(int index)? onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 10),
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton.icon(
                onPressed: onAddFood,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Food'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('No foods added yet', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            )
          else
            ...items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return InkWell(
                onTap: () => onItemTap?.call(idx),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(item.quantity, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                            const SizedBox(height: 8),
                            Text('${item.calories} kcal • P ${item.protein}g • C ${item.carbs}g • F ${item.fat}g', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
