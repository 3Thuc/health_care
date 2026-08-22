import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key, required this.isDark, required this.primary, required this.background, required this.surface});

  final bool isDark;
  final Color primary;
  final Color background;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final muted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 100.0;
      final padding = (height * .08).clamp(3.0, 8.0);
      final contentHeight = height - (padding * 2);
      final headerHeight = contentHeight * .13;
      final gap = contentHeight * .06;
      final progressHeight = contentHeight * .08;
      final buttonHeight = contentHeight * .18;

      return Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // mini header
            Row(
              children: [
                Container(width: headerHeight, height: headerHeight, decoration: BoxDecoration(color: primary, shape: BoxShape.circle)),
                SizedBox(width: headerHeight * .9),
                Expanded(child: Container(height: headerHeight, color: muted.withValues(alpha: .18))),
              ],
            ),
            SizedBox(height: gap),
            // two small cards row
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                  Expanded(
                    child: Container(
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ],
              ),
            ),
            SizedBox(height: gap),
            // progress bar
            Container(
              height: progressHeight,
              decoration: BoxDecoration(color: surface.withValues(alpha: .5), borderRadius: BorderRadius.circular(8)),
              child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: 0.65, child: Container(decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)))),
            ),
            SizedBox(height: gap),
            // primary button
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: buttonHeight,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: FittedBox(child: Text('Primary', style: TextStyle(color: textColor, fontWeight: FontWeight.w700))),
              ),
            ),
          ],
        ),
      );
    });
  }
}
