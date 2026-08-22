import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'theme_option_card.dart';
import 'theme_preview.dart';
import '../../../core/theme/theme_controller.dart';

class AppearanceSection extends StatefulWidget {
  const AppearanceSection({super.key});

  @override
  State<AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  late ThemeMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = ThemeController.instance.currentThemeMode;
    ThemeController.instance.addListener(_onController);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onController);
    super.dispose();
  }

  void _onController() {
    setState(() {
      _mode = ThemeController.instance.currentThemeMode;
    });
  }

  void _select(ThemeMode mode) async {
    await ThemeController.instance.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 12.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appearance', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Choose how the app looks', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final twoColumns = constraints.maxWidth < 500;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              SizedBox(
                width: isWide ? (constraints.maxWidth - spacing * 2) / 3 : (twoColumns ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth),
                child: ThemeOptionCard(
                  title: 'Light',
                  subtitle: 'Bright and clean',
                  isSelected: _mode == ThemeMode.light,
                  onTap: () => _select(ThemeMode.light),
                  previewBuilder: (c) => ThemePreview(isDark: false, primary: AppColors.primaryLight, background: AppColors.lightBackground, surface: AppColors.lightSurface),
                  selectedTint: AppColors.primaryLight,
                  borderColor: AppColors.primaryLight,
                ),
              ),
              SizedBox(
                width: isWide ? (constraints.maxWidth - spacing * 2) / 3 : (twoColumns ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth),
                child: ThemeOptionCard(
                  title: 'Dark',
                  subtitle: 'Premium and calm',
                  isSelected: _mode == ThemeMode.dark,
                  onTap: () => _select(ThemeMode.dark),
                  previewBuilder: (c) => ThemePreview(isDark: true, primary: AppColors.primaryDark, background: AppColors.darkBackground, surface: AppColors.darkSurface),
                  selectedTint: AppColors.primaryDark,
                  borderColor: AppColors.primaryDark,
                ),
              ),
              SizedBox(
                width: isWide ? (constraints.maxWidth - spacing * 2) / 3 : (twoColumns ? constraints.maxWidth : constraints.maxWidth),
                child: ThemeOptionCard(
                  title: 'System Default',
                  subtitle: 'Follow device settings',
                  isSelected: _mode == ThemeMode.system,
                  onTap: () => _select(ThemeMode.system),
                  previewBuilder: (c) => Row(
                    children: [
                      Expanded(child: ThemePreview(isDark: false, primary: AppColors.primaryLight, background: AppColors.lightBackground, surface: AppColors.lightSurface)),
                      const SizedBox(width: 6),
                      Expanded(child: ThemePreview(isDark: true, primary: AppColors.primaryDark, background: AppColors.darkBackground, surface: AppColors.darkSurface)),
                    ],
                  ),
                  selectedTint: AppColors.primaryLight,
                  borderColor: AppColors.primaryLight,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 12),
      ],
    );
  }
}
