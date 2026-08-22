import 'package:flutter/material.dart';
import 'package:health_care/app/theme/app_colors.dart';
import 'package:health_care/app/theme/app_gradients.dart';

class NutritionSummaryPanel extends StatelessWidget {
  const NutritionSummaryPanel({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.primaryCyan.withValues(alpha: 0.12)
              : theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.primaryBlue.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Nutrition', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wideLayout = constraints.maxWidth >= 320;

              final caloriesColor = isDark ? AppColors.caloriesDark : AppColors.caloriesLight;
              final proteinColor = isDark ? AppColors.proteinDark : AppColors.proteinLight;
              final carbsColor = isDark ? AppColors.carbsDark : AppColors.carbsLight;
              final fatColor = isDark ? AppColors.fatDark : AppColors.fatLight;

              if (wideLayout) {
                return Column(
                  children: [
                    _MetricRow(label: 'Calories', value: '$calories kcal', color: caloriesColor, gradientColors: const [Color(0xFF3B82F6), Color(0xFF06B6D4)]),
                    const SizedBox(height: 10),
                    _MetricRow(label: 'Protein', value: '$protein g', color: proteinColor, gradientColors: const [Color(0xFF10B981), Color(0xFF14B8A6)]),
                    const SizedBox(height: 10),
                    _MetricRow(label: 'Carbs', value: '$carbs g', color: carbsColor, gradientColors: const [Color(0xFFF59E0B), Color(0xFFF97316)]),
                    const SizedBox(height: 10),
                    _MetricRow(label: 'Fat', value: '$fat g', color: fatColor, gradientColors: const [Color(0xFF8B5CF6), Color(0xFFA855F7)]),
                  ],
                );
              }

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _CompactMetricChip(label: 'Calories', value: '$calories kcal', color: caloriesColor, gradientColors: const [Color(0xFF3B82F6), Color(0xFF06B6D4)]),
                  _CompactMetricChip(label: 'Protein', value: '$protein g', color: proteinColor, gradientColors: const [Color(0xFF10B981), Color(0xFF14B8A6)]),
                  _CompactMetricChip(label: 'Carbs', value: '$carbs g', color: carbsColor, gradientColors: const [Color(0xFFF59E0B), Color(0xFFF97316)]),
                  _CompactMetricChip(label: 'Fat', value: '$fat g', color: fatColor, gradientColors: const [Color(0xFF8B5CF6), Color(0xFFA855F7)]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value, required this.color, required this.gradientColors});

  final String label;
  final String value;
  final Color color;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            shape: BoxShape.circle,
            boxShadow: isDark
                ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6)]
                : [],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65))),
      ],
    );
  }
}

class _CompactMetricChip extends StatelessWidget {
  const _CompactMetricChip({required this.label, required this.value, required this.color, required this.gradientColors});

  final String label;
  final String value;
  final Color color;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withValues(alpha: isDark ? 0.12 : 0.08),
            gradientColors[1].withValues(alpha: isDark ? 0.06 : 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? color.withValues(alpha: 0.15) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65), fontSize: 12)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
