import 'package:flutter/material.dart';

import 'widgets/metric_card.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text('Alex Carter', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Text('AC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, const Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today\'s summary', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Steps', style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text('8,245', style: theme.textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(height: 4),
                            Text('/ 10,000', maxLines: 1, style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                          ],
                        ),
                      ),
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(child: Icon(Icons.directions_run_rounded, color: Colors.white, size: 32)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                MetricCard(label: 'Calories', value: '1,650 kcal', icon: Icons.local_fire_department_rounded, color: const Color(0xFF2563EB)),
                MetricCard(label: 'Heart Rate', value: '72 bpm', icon: Icons.monitor_heart_rounded, color: const Color(0xFF0F172A)),
                MetricCard(label: 'Sleep', value: '7.2h', icon: Icons.bedtime_rounded, color: const Color(0xFF3B82F6)),
                MetricCard(label: 'Distance', value: '5.2 km', icon: Icons.route_rounded, color: const Color(0xFF64748B)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Today\'s meals', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Pill(label: 'Breakfast', value: 'Oats + berries'),
                _Pill(label: 'Lunch', value: 'Chicken salad'),
                _Pill(label: 'Dinner', value: 'Salmon bowl'),
                _Pill(label: 'Snack', value: 'Protein shake'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65))),
        ],
      ),
    );
  }
}
