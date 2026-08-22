import 'package:flutter/material.dart';

import '../../models/meal.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key, required this.meal});

  final MealItem meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withValues(alpha: 0.96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.18 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Color(meal.color).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(meal.icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 2),
                Text(meal.subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.62), fontSize: 11.5)),
                const SizedBox(height: 6),
                Text('${meal.calories} kcal • P ${meal.protein}g • C ${meal.carbs}g • F ${meal.fat}g', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.62), fontSize: 11.5)),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: Icon(Icons.add_circle_outline_rounded, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
