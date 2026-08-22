import 'package:flutter/material.dart';
import '../../models/muscle_rank_models.dart';

class MuscleFocusAreas extends StatelessWidget {
  final List<MuscleScore> strongest;
  final List<MuscleScore> focus;

  const MuscleFocusAreas({
    super.key,
    required this.strongest,
    required this.focus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Column(
            title: 'STRONGEST',
            icon: Icons.local_fire_department,
            color: Colors.orange,
            scores: strongest,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _Column(
            title: 'FOCUS AREAS',
            icon: Icons.track_changes,
            color: Theme.of(context).colorScheme.primary,
            scores: focus,
          ),
        ),
      ],
    );
  }
}

class _Column extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<MuscleScore> scores;

  const _Column({
    required this.title,
    required this.icon,
    required this.color,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...scores.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.muscleGroup,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: s.tier.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: s.tier.color.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        s.tier.displayName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: s.tier.color,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          if (scores.isEmpty)
            Text(
              'No data yet',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
