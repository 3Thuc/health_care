import 'package:flutter/material.dart';

import '../../models/nutrition_day.dart';

class MealListCard extends StatelessWidget {
  const MealListCard({
    super.key,
    required this.meal,
    required this.onAddFood,
  });

  final NutritionMealData meal;
  final VoidCallback onAddFood;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(meal.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75))),
                const SizedBox(height: 4),
                Text(meal.quantity, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
                const SizedBox(height: 8),
                Text('${meal.calories} kcal • P ${meal.protein}g • C ${meal.carbs}g • F ${meal.fat}g', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65), fontSize: 12)),
              ],
            ),
          ),
          IconButton(onPressed: onAddFood, icon: const Icon(Icons.add_circle_outline_rounded)),
        ],
      ),
    );
  }
}
