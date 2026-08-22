import 'package:flutter/material.dart';

class NutritionTargetCard extends StatelessWidget {
  const NutritionTargetCard({super.key, required this.label, required this.current, required this.target, required this.color, this.gradientColors});

  final String label;
  final int current;
  final int target;
  final Color color;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fraction = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.06) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? color.withValues(alpha: 0.12) : theme.colorScheme.onSurface.withValues(alpha: 0.04),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                gradient: gradientColors != null
                    ? LinearGradient(colors: gradientColors!)
                    : null,
                color: gradientColors == null ? color : null,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: isDark ? color.withValues(alpha: 0.12) : theme.colorScheme.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: gradientColors != null
                        ? LinearGradient(colors: gradientColors!)
                        : LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: isDark
                        ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)]
                        : [],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$current / $target', style: theme.textTheme.bodySmall),
          Text(label == 'Calories' ? 'kcal' : 'g', style: theme.textTheme.bodySmall),
        ]),
      ]),
    );
  }
}
