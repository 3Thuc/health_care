import 'package:flutter/material.dart';
import '../../../app/theme/app_gradients.dart';
import 'appearance_section.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'health_sync_page.dart';
import 'notifications_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.isDarkMode, required this.onThemeModeChanged});

  final bool isDarkMode;
  final VoidCallback onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final sections = [
      _SettingsSection(
        title: 'Account',
        items: [
          _SettingsTile('Edit Profile', Icons.person_outline, (_) => const EditProfilePage()),
          _SettingsTile('Change Password', Icons.lock_outline, (_) => const ChangePasswordPage()),
        ],
      ),
      _SettingsSection(
        title: 'Health',
        items: [
          _SettingsTile('Health Sync', Icons.health_and_safety_outlined, (_) => const HealthSyncPage()),
          _SettingsTile('Notifications', Icons.notifications_outlined, (_) => const NotificationsPage()),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
          children: [
            ...sections.expand((section) => [
                  Text(section.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...section.items.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          gradient: AppGradients.cardGradient(Theme.of(context).brightness),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: item.onTap)),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.08),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(item.icon, color: Theme.of(context).colorScheme.primary, size: 20),
                          ),
                          title: Text(item.label),
                          trailing: const Icon(Icons.chevron_right_rounded),
                        ),
                      )),
                  const SizedBox(height: 12),
                ]),
            Text('Appearance', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            const AppearanceSection(),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Logged out successfully'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection {
  const _SettingsSection({required this.title, required this.items});

  final String title;
  final List<_SettingsTile> items;
}

class _SettingsTile {
  const _SettingsTile(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final WidgetBuilder onTap;
}
