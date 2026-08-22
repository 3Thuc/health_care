import 'package:flutter/material.dart';

enum MuscleRankTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  master,
  challenger,
}

extension MuscleRankTierExt on MuscleRankTier {
  String get displayName {
    switch (this) {
      case MuscleRankTier.bronze: return 'BRONZE';
      case MuscleRankTier.silver: return 'SILVER';
      case MuscleRankTier.gold: return 'GOLD';
      case MuscleRankTier.platinum: return 'PLATINUM';
      case MuscleRankTier.diamond: return 'DIAMOND';
      case MuscleRankTier.master: return 'MASTER';
      case MuscleRankTier.challenger: return 'CHALLENGER';
    }
  }

  Color get color {
    switch (this) {
      case MuscleRankTier.bronze: return const Color(0xFFCD7F32);
      case MuscleRankTier.silver: return const Color(0xFFC0C0C0);
      case MuscleRankTier.gold: return const Color(0xFFFFD700);
      case MuscleRankTier.platinum: return const Color(0xFFE5E4E2);
      case MuscleRankTier.diamond: return const Color(0xFFB9F2FF);
      case MuscleRankTier.master: return const Color(0xFFFF00FF); // Neon purple/pink
      case MuscleRankTier.challenger: return const Color(0xFFFF4500); // OrangeRed/Fiery
    }
  }
}

class MuscleScore {
  final String muscleGroup;
  final MuscleRankTier tier;
  final int score;

  const MuscleScore({
    required this.muscleGroup,
    required this.tier,
    required this.score,
  });
}
