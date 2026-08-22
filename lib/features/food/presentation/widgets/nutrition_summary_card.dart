import 'package:flutter/material.dart';

class NutritionSummaryCard extends StatelessWidget {
  const NutritionSummaryCard({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Nutrition', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _ProgressRow(label: 'Calories', current: calories, target: targetCalories, color: const Color(0xFF2563EB)),
          const SizedBox(height: 12),
          _ProgressRow(label: 'Protein', current: protein, target: targetProtein, color: const Color(0xFF0F172A)),
          const SizedBox(height: 12),
          _ProgressRow(label: 'Carbs', current: carbs, target: targetCarbs, color: const Color(0xFF3B82F6)),
          const SizedBox(height: 12),
          _ProgressRow(label: 'Fat', current: fat, target: targetFat, color: const Color(0xFF64748B)),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
  });

  final String label;
  final int current;
  final int target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final percent = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$current / $target', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65))),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: percent,
            backgroundColor: Colors.grey.shade200,
            color: color,
          ),
        ),
      ],
    );
  }
}
