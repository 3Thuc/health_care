import 'package:flutter/material.dart';
// no direct AppColors dependency here

class ThemeOptionCard extends StatelessWidget {
  const ThemeOptionCard({super.key, required this.title, required this.subtitle, required this.isSelected, required this.onTap, required this.previewBuilder, required this.selectedTint, required this.borderColor});

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget Function(BuildContext) previewBuilder;
  final Color selectedTint;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title theme option',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? selectedTint.withValues(alpha: 0.12) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? borderColor : Colors.transparent, width: 1.6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.25 : 0.06),
              blurRadius: isSelected ? 22 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: borderColor, shape: BoxShape.circle),
                      child: const Icon(Icons.check, size: 14, color: Colors.white),
                    ),
                ],
              ),
              const SizedBox(height: 8),
                // Subtitle may wrap but should not grow without bound. Limit to two lines.
                Text(subtitle, style: theme.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                // Responsive preview: derive a reasonable fixed height from available width
                LayoutBuilder(builder: (c, constraints) {
                  final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0 ? constraints.maxWidth : MediaQuery.of(c).size.width;
                  // compute a tight height to avoid overflow; reduce ratio so title/subtitle fit
                  final calculated = (w * 0.45).clamp(44.0, 140.0);
                  return SizedBox(
                    height: calculated,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Align(alignment: Alignment.topCenter, child: previewBuilder(c)),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
