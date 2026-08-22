import 'package:flutter/material.dart';
import '../../../../app/theme/app_gradients.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  color.withValues(alpha: 0.10),
                  theme.colorScheme.surface.withValues(alpha: 0.7),
                ]
              : [
                  Colors.white,
                  color.withValues(alpha: 0.06),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? color.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? color.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: isDark ? 20 : 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useCompactLayout = constraints.maxWidth < 150;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: useCompactLayout ? 30 : 36,
                height: useCompactLayout ? 30 : 36,
                decoration: AppGradients.iconGradientDecoration(color, theme.brightness),
                child: Icon(icon, color: color, size: useCompactLayout ? 16 : 18),
              ),
              SizedBox(height: useCompactLayout ? 6 : 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: useCompactLayout ? 10.5 : 12,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  '$value $unit',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: useCompactLayout ? 15 : 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
