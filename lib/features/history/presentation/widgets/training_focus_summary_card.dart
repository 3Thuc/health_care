import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/muscle_rank_models.dart';
import 'body_painter.dart';

class TrainingFocusSummaryCard extends StatefulWidget {
  final List<MuscleScore> scores;
  final int score;
  final MuscleRankTier tier;
  final int diff;
  final MuscleScore? strongest;
  final MuscleScore? focusArea;
  final VoidCallback onViewAnalytics;

  const TrainingFocusSummaryCard({
    super.key,
    required this.scores,
    required this.score,
    required this.tier,
    required this.diff,
    this.strongest,
    this.focusArea,
    required this.onViewAnalytics,
  });

  @override
  State<TrainingFocusSummaryCard> createState() => _TrainingFocusSummaryCardState();
}

class _TrainingFocusSummaryCardState extends State<TrainingFocusSummaryCard> {
  BodyView _view = BodyView.front;

  static const Map<String, String> _muscleGroupToSlug = {
    'Chest': 'chest',
    'Back': 'upper-back',
    'Legs': 'quadriceps',
    'Arms': 'biceps', // Simplified map for mock data
    'Shoulders': 'deltoids',
    'Core': 'abs',
  };

  static const Map<String, String> _slugToVietnamese = {
    'chest': 'Ngực',
    'obliques': 'Cơ liên sườn',
    'abs': 'Bụng',
    'biceps': 'Tay trước (Biceps)',
    'triceps': 'Tay sau (Triceps)',
    'neck': 'Cổ',
    'trapezius': 'Cầu vai',
    'deltoids': 'Vai (Deltoids)',
    'adductors': 'Cơ khép đùi',
    'quadriceps': 'Đùi trước (Quads)',
    'knees': 'Đầu gối',
    'tibialis': 'Cẳng chân trước',
    'calves': 'Bắp chân',
    'forearm': 'Cẳng tay',
    'hands': 'Bàn tay',
    'ankles': 'Cổ chân',
    'feet': 'Bàn chân',
    'upper-back': 'Lưng trên / Xô',
    'lower-back': 'Lưng dưới',
    'gluteal': 'Mông',
    'hamstring': 'Đùi sau (Hamstrings)',
  };

  void _showMuscleDetails(String slug, MuscleRankTier? tier) {
    final viName = _slugToVietnamese[slug] ?? slug;
    final scoreObj = widget.scores.where((s) => _muscleGroupToSlug[s.muscleGroup] == slug).firstOrNull;
    final progress = scoreObj?.score ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: getTierColor(tier),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      viName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    tier != null ? tier.displayName : 'NO DATA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: getTierColor(tier),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress:',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    '$progress%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                color: getTierColor(tier),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, MuscleRankTier> muscleTiers = {};
    for (var s in widget.scores) {
      final slug = _muscleGroupToSlug[s.muscleGroup];
      if (slug != null) {
        muscleTiers[slug] = s.tier;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.tier.color.withValues(alpha: 0.1),
            widget.tier.color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.tier.color.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Overall Muscle Score',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.tier.displayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: widget.tier.color,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.score}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 2.0, left: 4.0),
                child: Text(
                  '/ 100',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                widget.diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: widget.diff >= 0 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.diff.abs()} vs last period',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: widget.diff >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Segmented Control + Body Map
          Center(
            child: CupertinoSlidingSegmentedControl<BodyView>(
              groupValue: _view,
              children: const {
                BodyView.front: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Front', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                BodyView.back: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              },
              onValueChanged: (v) {
                if (v != null) setState(() => _view = v);
              },
            ),
          ),
          const SizedBox(height: 24), // Increased spacing to prevent overlap
          
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.contain,
              child: SizedBox(
                width: 724,
                height: 1120,
                child: BodyMapView(
                  view: _view,
                  muscleTiers: muscleTiers,
                  onMuscleTap: (slug) {
                    _showMuscleDetails(slug, muscleTiers[slug] ?? MuscleRankTier.bronze);
                  },
                ),
              ),
            ),
            ),
          ),
          ),
          const SizedBox(height: 12),

          if (widget.strongest != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  const Text('Strongest: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(widget.strongest!.muscleGroup, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          if (widget.focusArea != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  const Text('Focus area: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(widget.focusArea!.muscleGroup, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onViewAnalytics,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Analytics',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
