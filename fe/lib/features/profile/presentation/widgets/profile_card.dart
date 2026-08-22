import 'package:flutter/material.dart';
import '../../../../app/theme/app_gradients.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.name, required this.email, required this.goal, required this.height, required this.onTap});

  final String name;
  final String email;
  final String goal;
  final String height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppGradients.cardGradient(theme.brightness),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? theme.colorScheme.primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(children: [
          // Gradient ring avatar
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primaryGradient,
              boxShadow: isDark ? AppGradients.primaryGlow(intensity: 0.2) : [],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.surface,
              child: Text(
                _initials(name),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(email, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.65))),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 6, children: [
                _GradientChip(label: goal),
                _GradientChip(label: height),
              ])
            ]),
          )
        ]),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 1).toUpperCase();
  }
}

class _GradientChip extends StatelessWidget {
  const _GradientChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                  theme.colorScheme.tertiary.withValues(alpha: 0.10),
                ]
              : [
                  theme.colorScheme.primary.withValues(alpha: 0.10),
                  theme.colorScheme.tertiary.withValues(alpha: 0.06),
                ],
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
        ),
      ),
      child: Text(label, style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
