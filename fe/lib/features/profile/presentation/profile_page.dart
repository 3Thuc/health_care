import 'package:flutter/material.dart';

import '../../settings/presentation/settings_page.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_card.dart';
import 'widgets/stat_card.dart';
import 'widgets/nutrition_target_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.isDarkMode, required this.onThemeModeChanged});

  final bool isDarkMode;
  final VoidCallback onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const name = 'Alex Carter';
    const email = 'alex.carter@email.com';
    const goal = 'Lose fat';
    const height = '180 cm';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
          children: [
            ProfileHeader(
              title: 'Profile',
              subtitle: 'Stay aligned with your goals',
              onSettings: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SettingsPage(isDarkMode: isDarkMode, onThemeModeChanged: onThemeModeChanged)),
              ),
            ),
            const SizedBox(height: 18),
            ProfileCard(name: name, email: email, goal: goal, height: height, onTap: () {}),
            const SizedBox(height: 20),
            Text('Your Stats', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: const [
                StatCard(label: 'Weight', value: '72 kg', icon: Icons.monitor_weight_outlined),
                StatCard(label: 'BMI', value: '22.2', icon: Icons.auto_graph_rounded),
                StatCard(label: 'Age', value: '28', icon: Icons.cake_rounded),
                StatCard(label: 'Goal', value: 'Lose fat', icon: Icons.flag_rounded),
              ],
            ),
            const SizedBox(height: 20),
            Text("Today's Targets", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            const Column(
              children: [
                NutritionTargetCard(label: 'Calories', current: 1850, target: 2200, color: Color(0xFF3B82F6), gradientColors: [Color(0xFF3B82F6), Color(0xFF06B6D4)]),
                SizedBox(height: 10),
                NutritionTargetCard(label: 'Protein', current: 125, target: 150, color: Color(0xFF10B981), gradientColors: [Color(0xFF10B981), Color(0xFF14B8A6)]),
                SizedBox(height: 10),
                NutritionTargetCard(label: 'Carbs', current: 210, target: 250, color: Color(0xFFF59E0B), gradientColors: [Color(0xFFF59E0B), Color(0xFFF97316)]),
                SizedBox(height: 10),
                NutritionTargetCard(label: 'Fat', current: 55, target: 70, color: Color(0xFF8B5CF6), gradientColors: [Color(0xFF8B5CF6), Color(0xFFA855F7)]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
