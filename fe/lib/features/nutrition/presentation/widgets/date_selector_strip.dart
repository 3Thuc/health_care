import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_gradients.dart';

class DateSelectorStrip extends StatelessWidget {
  const DateSelectorStrip({
    super.key,
    required this.selectedDate,
    required this.days,
    required this.onSelectDate,
  });

  final DateTime selectedDate;
  final List<DateTime> days;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 78,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 60) / 7;
          final tileWidth = itemWidth.clamp(0.0, double.infinity);

          return Row(
            children: List.generate(days.length, (index) {
              final day = days[index];
              final isSelected = day.year == selectedDate.year && day.month == selectedDate.month && day.day == selectedDate.day;

              return Padding(
                padding: EdgeInsets.only(right: index == days.length - 1 ? 0 : 10),
                child: GestureDetector(
                  onTap: () => onSelectDate(day),
                  child: Container(
                    width: tileWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: isSelected ? AppGradients.primaryGradient : null,
                      color: isSelected ? null : theme.colorScheme.surface,
                      boxShadow: isSelected && isDark
                          ? AppGradients.primaryGlow(intensity: 0.2)
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            DateFormat('EEE').format(day).substring(0, 3),
                            style: TextStyle(
                              color: isSelected ? Colors.white.withValues(alpha: 0.85) : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
