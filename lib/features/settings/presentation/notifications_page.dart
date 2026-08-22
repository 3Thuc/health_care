import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _workoutReminder = true;
  bool _mealReminder = true;
  bool _weeklySummary = false;
  bool _achievementAlerts = true;

  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification preferences updated!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Text(
              'Choose what notifications you want to receive and schedule reminders.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Reminders',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            // Workout reminder
            _buildNotificationSwitch(
              label: 'Daily Workout Reminder',
              subtitle: 'Remind me to do my scheduled workouts.',
              icon: Icons.fitness_center_rounded,
              value: _workoutReminder,
              onChanged: (val) => setState(() => _workoutReminder = val),
              theme: theme,
            ),
            const SizedBox(height: 12),

            // Time selector for reminders
            if (_workoutReminder) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppGradients.cardGradient(theme.brightness),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : theme.colorScheme.outline.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.access_time_filled_rounded, color: theme.colorScheme.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reminder Time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('Choose when to be reminded', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _selectTime,
                      child: Text(
                        _reminderTime.format(context),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            _buildNotificationSwitch(
              label: 'Meal Logs Reminder',
              subtitle: 'Gentle nudges to record your meals and water.',
              icon: Icons.restaurant_menu_rounded,
              value: _mealReminder,
              onChanged: (val) => setState(() => _mealReminder = val),
              theme: theme,
            ),
            const SizedBox(height: 24),

            Text(
              'Updates & Activities',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            _buildNotificationSwitch(
              label: 'Weekly Progress Reports',
              subtitle: 'Receive a summary of your steps and active minutes.',
              icon: Icons.bar_chart_rounded,
              value: _weeklySummary,
              onChanged: (val) => setState(() => _weeklySummary = val),
              theme: theme,
            ),
            const SizedBox(height: 12),

            _buildNotificationSwitch(
              label: 'Achievements & Badges',
              subtitle: 'Alerts when you reach active streak milestones.',
              icon: Icons.emoji_events_rounded,
              value: _achievementAlerts,
              onChanged: (val) => setState(() => _achievementAlerts = val),
              theme: theme,
            ),
            const SizedBox(height: 40),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _saveSettings,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: isDark ? AppGradients.primaryGlow(intensity: 0.2) : [],
                    ),
                    child: const Center(
                      child: Text(
                        'Save Preferences',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : theme.colorScheme.outline.withValues(alpha: 0.05),
        ),
      ),
      child: SwitchListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11)),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        value: value,
        onChanged: onChanged,
        activeTrackColor: theme.colorScheme.primary,
      ),
    );
  }
}
