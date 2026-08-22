import 'package:flutter/material.dart';
import '../../../../app/theme/app_gradients.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : theme.colorScheme.onSurface.withValues(alpha: 0.04),
        ),
        boxShadow: isDark
            ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.05), blurRadius: 12)]
            : [],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ShaderMask(
                shaderCallback: (bounds) => AppGradients.primaryGradient.createShader(bounds),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
            ),
          Text(label, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12)),
        ]),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
