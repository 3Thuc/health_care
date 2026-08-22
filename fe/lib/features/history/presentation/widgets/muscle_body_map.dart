import 'package:flutter/material.dart';
import '../../models/muscle_rank_models.dart';
import 'body_painter.dart';

class MuscleBodyMap extends StatefulWidget {
  final List<MuscleScore> scores;

  const MuscleBodyMap({super.key, required this.scores});

  @override
  State<MuscleBodyMap> createState() => _MuscleBodyMapState();
}

class _MuscleBodyMapState extends State<MuscleBodyMap> {
  bool _isFront = true;
  String? _selectedSlug;

  static const Map<String, String> _muscleGroupToSlug = {
    'Chest': 'chest',
    'Back': 'upper-back',
    'Legs': 'quadriceps',
    'Arms': 'biceps', // Simplified mapping for mock data
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

  void _onMuscleTapped(String slug) {
    setState(() {
      if (_selectedSlug == slug) {
        _selectedSlug = null;
      } else {
        _selectedSlug = slug;
      }
    });
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

    // Determine the selected muscle score if any
    MuscleScore? selectedScoreObj;
    if (_selectedSlug != null) {
      selectedScoreObj = widget.scores.where((s) => _muscleGroupToSlug[s.muscleGroup] == _selectedSlug).firstOrNull;
    }

    return Column(
      children: [
        // Front / Back Toggle
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleBtn('FRONT', _isFront, () {
                setState(() {
                  _isFront = true;
                  _selectedSlug = null;
                });
              }),
              _buildToggleBtn('BACK', !_isFront, () {
                setState(() {
                  _isFront = false;
                  _selectedSlug = null;
                });
              }),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Body Map Interactive View
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.65, // 65% of available width
          child: BodyMapView(
            view: _isFront ? BodyView.front : BodyView.back,
            muscleTiers: muscleTiers,
            onMuscleTap: _onMuscleTapped,
          ),
        ),
        
        // Compact Detail Card (appears below map when a muscle is selected)
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: _selectedSlug != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: _buildDetailCard(context, _selectedSlug!, selectedScoreObj),
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context, String slug, MuscleScore? scoreObj) {
    final viName = _slugToVietnamese[slug] ?? slug;
    final MuscleRankTier? tier = scoreObj?.tier;
    final scoreValue = scoreObj?.score ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: getTierColor(tier).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    tier != null ? tier.displayName : 'NO DATA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: getTierColor(tier),
                    ),
                  ),
                  if (tier != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '↑ +4 vs previous period', // Mocked trend
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade400,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$scoreValue',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                ' / 100',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
