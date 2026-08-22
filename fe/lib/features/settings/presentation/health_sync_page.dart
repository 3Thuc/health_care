import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';

class HealthSyncPage extends StatefulWidget {
  const HealthSyncPage({super.key});

  @override
  State<HealthSyncPage> createState() => _HealthSyncPageState();
}

class _HealthSyncPageState extends State<HealthSyncPage> {
  bool _appleHealthSynced = true;
  bool _googleFitSynced = false;
  bool _stravaSynced = false;
  bool _fitbitSynced = false;

  bool _isSyncing = false;
  String _syncStatus = "All services are up to date";
  String _lastSyncedTime = "Synced 2 mins ago";

  Future<void> _triggerSync() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
      _syncStatus = "Syncing health & workout data...";
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 2200));

    if (mounted) {
      setState(() {
        _isSyncing = false;
        _syncStatus = "Sync complete!";
        _lastSyncedTime = "Synced just now";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Health data synchronized successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Sync'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppGradients.cardGradient(theme.brightness),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                      ? AppColors.primaryBlue.withValues(alpha: 0.1)
                      : theme.colorScheme.outline.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (_isSyncing ? Colors.blue : AppColors.success).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isSyncing ? Icons.sync : Icons.cloud_done_outlined,
                          color: _isSyncing ? Colors.blue : AppColors.success,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _syncStatus,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _lastSyncedTime,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_isSyncing) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: const LinearProgressIndicator(
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text(
              'Connected Services',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            // Apple Health / Google Fit switch
            _buildServiceTile(
              label: 'Apple Health',
              subtitle: 'Sync heart rate, steps, and activity metrics.',
              icon: Icons.favorite_rounded,
              iconColor: Colors.redAccent,
              value: _appleHealthSynced,
              onChanged: (val) => setState(() => _appleHealthSynced = val),
              theme: theme,
            ),
            const SizedBox(height: 12),

            _buildServiceTile(
              label: 'Google Fit',
              subtitle: 'Sync sleep, steps, and daily active minutes.',
              icon: Icons.fitbit_rounded,
              iconColor: Colors.teal,
              value: _googleFitSynced,
              onChanged: (val) => setState(() => _googleFitSynced = val),
              theme: theme,
            ),
            const SizedBox(height: 12),

            _buildServiceTile(
              label: 'Strava',
              subtitle: 'Sync outdoor runs, cycling workouts, and GPS data.',
              icon: Icons.directions_run_rounded,
              iconColor: Colors.orange,
              value: _stravaSynced,
              onChanged: (val) => setState(() => _stravaSynced = val),
              theme: theme,
            ),
            const SizedBox(height: 12),

            _buildServiceTile(
              label: 'Fitbit Integration',
              subtitle: 'Sync active calories burned and resting HR.',
              icon: Icons.watch_rounded,
              iconColor: Colors.blueAccent,
              value: _fitbitSynced,
              onChanged: (val) => setState(() => _fitbitSynced = val),
              theme: theme,
            ),
            const SizedBox(height: 36),

            // Sync now button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _triggerSync,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: _isSyncing ? null : AppGradients.primaryGradient,
                      color: _isSyncing ? theme.colorScheme.onSurface.withValues(alpha: 0.1) : null,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: isDark && !_isSyncing ? AppGradients.primaryGlow(intensity: 0.2) : [],
                    ),
                    child: const Center(
                      child: Text(
                        'Sync Now',
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

  Widget _buildServiceTile({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
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
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        value: value,
        onChanged: onChanged,
        activeTrackColor: theme.colorScheme.primary,
      ),
    );
  }
}
