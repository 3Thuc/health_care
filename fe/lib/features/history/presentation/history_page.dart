import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../models/muscle_rank_models.dart';
import 'widgets/muscle_score_card.dart';
import 'widgets/muscle_body_map.dart';
import 'widgets/muscle_rank_legend.dart';
import 'widgets/muscle_focus_areas.dart';
import 'widgets/training_focus_summary_card.dart';

// ─── Period mode ─────────────────────────────────────────────
enum _Period { week, month, year }

/// A single logged data-entry point on the analytics chart.
class _ChartPoint {
  const _ChartPoint({
    required this.xNorm, // position 0.0–1.0 within the period
    required this.label, // x-axis label
    required this.calValue,
    required this.workValue,
    required this.wtValue,
  });
  final double xNorm;
  final String label;
  final double calValue, workValue, wtValue;
}

// ─── Page ────────────────────────────────────────────────────
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Shared mock data
    const mockScores = [
      MuscleScore(muscleGroup: 'Chest', tier: MuscleRankTier.diamond, score: 85),
      MuscleScore(muscleGroup: 'Back', tier: MuscleRankTier.silver, score: 40),
      MuscleScore(muscleGroup: 'Legs', tier: MuscleRankTier.platinum, score: 70),
      MuscleScore(muscleGroup: 'Arms', tier: MuscleRankTier.bronze, score: 20),
      MuscleScore(muscleGroup: 'Shoulders', tier: MuscleRankTier.gold, score: 55),
      MuscleScore(muscleGroup: 'Core', tier: MuscleRankTier.silver, score: 45),
    ];
    
    const mockStrongest = [
      MuscleScore(muscleGroup: 'Chest', tier: MuscleRankTier.diamond, score: 85),
      MuscleScore(muscleGroup: 'Legs', tier: MuscleRankTier.platinum, score: 70),
    ];
    
    const mockFocus = [
      MuscleScore(muscleGroup: 'Arms', tier: MuscleRankTier.bronze, score: 20),
      MuscleScore(muscleGroup: 'Back', tier: MuscleRankTier.silver, score: 40),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(
            isDark: isDark,
            strongest: mockStrongest.firstOrNull,
            focusArea: mockFocus.firstOrNull,
            onViewAnalytics: () => _tabController.animateTo(1),
          ),
          _AnalyticsTab(
            isDark: isDark,
            scores: mockScores,
            strongest: mockStrongest,
            focus: mockFocus,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// OVERVIEW TAB
// ─────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.isDark,
    this.strongest,
    this.focusArea,
    required this.onViewAnalytics,
  });
  final bool isDark;
  final MuscleScore? strongest;
  final MuscleScore? focusArea;
  final VoidCallback onViewAnalytics;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      children: [
        // Top Section: Overall progress / chart hiện tại
        _StreakCard(isDark: isDark),
        const SizedBox(height: 20),
        const _KpiGrid(),
        const SizedBox(height: 32),
        
        // Training Focus Section
        TrainingFocusSummaryCard(
          scores: const [
            MuscleScore(muscleGroup: 'Chest', tier: MuscleRankTier.diamond, score: 85),
            MuscleScore(muscleGroup: 'Back', tier: MuscleRankTier.silver, score: 40),
            MuscleScore(muscleGroup: 'Legs', tier: MuscleRankTier.platinum, score: 70),
            MuscleScore(muscleGroup: 'Arms', tier: MuscleRankTier.bronze, score: 20),
            MuscleScore(muscleGroup: 'Shoulders', tier: MuscleRankTier.gold, score: 55),
            MuscleScore(muscleGroup: 'Core', tier: MuscleRankTier.silver, score: 45),
          ],
          score: 72,
          tier: MuscleRankTier.platinum,
          diff: 8,
          strongest: strongest,
          focusArea: focusArea,
          onViewAnalytics: onViewAnalytics,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ANALYTICS TAB
// ─────────────────────────────────────────────────────────────

class _AnalyticsTab extends StatefulWidget {
  const _AnalyticsTab({
    required this.isDark,
    required this.scores,
    required this.strongest,
    required this.focus,
  });
  final bool isDark;
  final List<MuscleScore> scores;
  final List<MuscleScore> strongest;
  final List<MuscleScore> focus;

  @override
  State<_AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<_AnalyticsTab> {
  _Period _period = _Period.month;
  int _offset = 0;
  int _selectedIdx = 2; // default: day 13 (index 2) in month view

  // ── Sparse data: only actual logged dates ─────────────────

  // Week: all 7 days (Mon-Sun)
  static const _weekPoints = [
    _ChartPoint(
      xNorm: 0 / 6,
      label: 'Mon',
      calValue: 1850,
      workValue: 45,
      wtValue: 72.1,
    ),
    _ChartPoint(
      xNorm: 1 / 6,
      label: 'Tue',
      calValue: 2100,
      workValue: 60,
      wtValue: 72.0,
    ),
    _ChartPoint(
      xNorm: 2 / 6,
      label: 'Wed',
      calValue: 1650,
      workValue: 0,
      wtValue: 71.9,
    ),
    _ChartPoint(
      xNorm: 3 / 6,
      label: 'Thu',
      calValue: 2300,
      workValue: 55,
      wtValue: 71.8,
    ),
    _ChartPoint(
      xNorm: 4 / 6,
      label: 'Fri',
      calValue: 1980,
      workValue: 40,
      wtValue: 71.7,
    ),
    _ChartPoint(
      xNorm: 5 / 6,
      label: 'Sat',
      calValue: 2200,
      workValue: 70,
      wtValue: 71.6,
    ),
    _ChartPoint(
      xNorm: 6 / 6,
      label: 'Sun',
      calValue: 1750,
      workValue: 0,
      wtValue: 71.5,
    ),
  ];

  List<_ChartPoint> get _monthPoints {
    final now = DateTime.now();
    final targetDate = DateTime(now.year, now.month - _offset, 1);
    final daysInMonth = DateTime(targetDate.year, targetDate.month + 1, 0).day;
    final denom = (daysInMonth - 1).toDouble();

    final days = {1, 7, 14, 21, 28, daysInMonth}.toList()..sort();

    return days.map((d) {
      // Mock data variations
      final cal = 1800.0 + (d * 47 % 500);
      final work = 30.0 + (d * 11 % 40);
      final wt = 72.0 - (d / 20);
      return _ChartPoint(
        xNorm: (d - 1) / denom,
        label: '$d',
        calValue: cal,
        workValue: work,
        wtValue: wt,
      );
    }).toList();
  }

  // Year: one point per month (monthly avg)
  static const _yearPoints = [
    _ChartPoint(
      xNorm: 0 / 11,
      label: 'Jan',
      calValue: 1900,
      workValue: 38,
      wtValue: 74.0,
    ),
    _ChartPoint(
      xNorm: 1 / 11,
      label: 'Feb',
      calValue: 1850,
      workValue: 42,
      wtValue: 73.5,
    ),
    _ChartPoint(
      xNorm: 2 / 11,
      label: 'Mar',
      calValue: 2000,
      workValue: 50,
      wtValue: 73.0,
    ),
    _ChartPoint(
      xNorm: 3 / 11,
      label: 'Apr',
      calValue: 2100,
      workValue: 48,
      wtValue: 72.5,
    ),
    _ChartPoint(
      xNorm: 4 / 11,
      label: 'May',
      calValue: 1980,
      workValue: 52,
      wtValue: 72.0,
    ),
    _ChartPoint(
      xNorm: 5 / 11,
      label: 'Jun',
      calValue: 2200,
      workValue: 55,
      wtValue: 71.5,
    ),
    _ChartPoint(
      xNorm: 6 / 11,
      label: 'Jul',
      calValue: 2100,
      workValue: 60,
      wtValue: 71.0,
    ),
    _ChartPoint(
      xNorm: 7 / 11,
      label: 'Aug',
      calValue: 2300,
      workValue: 65,
      wtValue: 70.5,
    ),
    _ChartPoint(
      xNorm: 8 / 11,
      label: 'Sep',
      calValue: 2050,
      workValue: 58,
      wtValue: 71.0,
    ),
    _ChartPoint(
      xNorm: 9 / 11,
      label: 'Oct',
      calValue: 1950,
      workValue: 50,
      wtValue: 71.5,
    ),
    _ChartPoint(
      xNorm: 10 / 11,
      label: 'Nov',
      calValue: 2100,
      workValue: 45,
      wtValue: 72.0,
    ),
    _ChartPoint(
      xNorm: 11 / 11,
      label: 'Dec',
      calValue: 1850,
      workValue: 40,
      wtValue: 72.5,
    ),
  ];

  List<_ChartPoint> get _points => switch (_period) {
    _Period.week => _weekPoints,
    _Period.month => _monthPoints,
    _Period.year => _yearPoints,
  };

  String get _chartTitle => switch (_period) {
    _Period.week => 'Weekly Overview',
    _Period.month => 'Monthly Overview',
    _Period.year => 'Yearly Overview',
  };

  String get _periodLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    return switch (_period) {
      _Period.week => 'Week of Aug ${math.max(1, 11 - _offset * 7)}',
      _Period.month => () {
        final mi = ((now.month - 1 - _offset) % 12 + 12) % 12;
        return '${months[mi]} ${now.year - (now.month - 1 - _offset < 0 ? 1 : 0)}';
      }(),
      _Period.year => '${now.year - _offset}',
    };
  }

  void _onPeriodChanged(_Period p) {
    setState(() {
      _period = p;
      _offset = 0;
      _selectedIdx = 0;
    });
  }

  // Find the nearest data point to a tap position
  void _onSelectAt(double dx, double totalWidth) {
    final pts = _points;
    if (pts.isEmpty) return;
    const lp = _MultiLinePainter.leftPad;
    const rp = _MultiLinePainter.rightPad;
    final chartW = totalWidth - lp - rp;
    final chartX = dx - lp;
    int nearest = 0;
    double minDist = double.infinity;
    for (int i = 0; i < pts.length; i++) {
      final dist = (pts[i].xNorm * chartW - chartX).abs();
      if (dist < minDist) {
        minDist = dist;
        nearest = i;
      }
    }
    if (nearest != _selectedIdx) setState(() => _selectedIdx = nearest);
  }

  static const _muscleBreakdown = <Map<String, Object>>[
    {
      'label': 'Chest / Triceps',
      'pct': 0.24,
      'color': Color(0xFF3B82F6),
      'icon': '🏋️',
    },
    {
      'label': 'Back / Biceps',
      'pct': 0.21,
      'color': Color(0xFFEC4899),
      'icon': '🚣',
    },
    {'label': 'Legs', 'pct': 0.20, 'color': Color(0xFF8B5CF6), 'icon': '🦵'},
    {
      'label': 'Shoulders',
      'pct': 0.18,
      'color': Color(0xFFF97316),
      'icon': '🙌',
    },
    {'label': 'Cardio', 'pct': 0.12, 'color': Color(0xFF10B981), 'icon': '🏃'},
    {'label': 'Core', 'pct': 0.05, 'color': Color(0xFF06B6D4), 'icon': '🧘'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;
    final pts = _points;
    final idx = _selectedIdx.clamp(0, pts.length - 1);
    final sel = pts[idx];
    final cal = sel.calValue;
    final work = sel.workValue;
    final wt = sel.wtValue;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      children: [
        // ── Period selector ──────────────────────────────
        _PeriodSelector(
          selected: _period,
          isDark: isDark,
          onChanged: _onPeriodChanged,
        ),
        const SizedBox(height: 16),

        // ── Big chart card ───────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
          decoration: BoxDecoration(
            gradient: AppGradients.cardGradient(theme.brightness),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : theme.colorScheme.outline.withValues(alpha: 0.07),
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 20,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: title + legend
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _chartTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _periodLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _LegendChip('Calories', Color(0xFF3B82F6)),
                      SizedBox(height: 4),
                      _LegendChip('Workout', Color(0xFF10B981)),
                      SizedBox(height: 4),
                      _LegendChip('Weight', Color(0xFF8B5CF6)),
                    ],
                  ),
                ],
              ),
              // Navigation arrows (prev/next period)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 22),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Previous period',
                    onPressed: () => setState(() => _offset++),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      size: 22,
                      color: _offset > 0
                          ? null
                          : theme.colorScheme.onSurface.withValues(alpha: 0.25),
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Next period',
                    onPressed: _offset > 0
                        ? () => setState(() => _offset--)
                        : null,
                  ),
                ],
              ),
              // The interactive chart
              LayoutBuilder(
                builder: (ctx, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (d) =>
                        _onSelectAt(d.localPosition.dx, constraints.maxWidth),
                    onHorizontalDragUpdate: (d) =>
                        _onSelectAt(d.localPosition.dx, constraints.maxWidth),
                    child: CustomPaint(
                      size: Size(constraints.maxWidth, 210),
                      painter: _MultiLinePainter(
                        points: pts,
                        selectedIdx: idx,
                        isDark: isDark,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Selected point stats ──────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppGradients.cardGradient(theme.brightness),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : theme.colorScheme.outline.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(
                'Calories',
                '${cal.toInt()} kcal',
                const Color(0xFF3B82F6),
              ),
              Container(
                width: 1,
                height: 36,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
              _StatChip(
                'Workout',
                '${work.toInt()} min',
                const Color(0xFF10B981),
              ),
              Container(
                width: 1,
                height: 36,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
              _StatChip(
                'Weight',
                '${wt.toStringAsFixed(1)} kg',
                const Color(0xFF8B5CF6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Monthly summary strip ─────────────────────────
        _MonthlyHighlightCard(isDark: isDark),
        const SizedBox(height: 24),

        // ── Muscle group focus breakdown ──────────────────
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'TRAINING FOCUS',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        
        // Overall Muscle Score
        const MuscleScoreCard(
          score: 72,
          tier: MuscleRankTier.platinum,
          diff: 8,
        ),
        const SizedBox(height: 24),
        
        // Body Map
        MuscleBodyMap(scores: widget.scores),
        const SizedBox(height: 24),
        
        // Rank Legend
        const MuscleRankLegend(),
        const SizedBox(height: 24),
        
        // Focus Areas
        MuscleFocusAreas(
          strongest: widget.strongest,
          focus: widget.focus,
        ),
        const SizedBox(height: 24),

        // ── Consistency heatmap ───────────────────────────
        Text(
          'Training Consistency',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        _ConsistencyGrid(isDark: isDark),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MULTI-LINE CHART PAINTER  (sparse data + Y-axis)
// ─────────────────────────────────────────────────────────────

class _MultiLinePainter extends CustomPainter {
  const _MultiLinePainter({
    required this.points,
    required this.selectedIdx,
    required this.isDark,
  });

  final List<_ChartPoint> points;
  final int selectedIdx;
  final bool isDark;

  static const topPad = 8.0;
  static const botPad = 28.0;
  static const leftPad = 38.0; // space for Y-axis labels
  static const rightPad = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final n = points.length;
    if (n < 2) return;

    final chartH = size.height - topPad - botPad;
    final chartW = size.width - leftPad - rightPad;

    final calNorm = _normSeries((p) => p.calValue);
    final workNorm = _normSeries((p) => p.workValue);
    final wtNorm = _normSeries((p) => p.wtValue);

    _drawYAxis(canvas, size, chartH, chartW);
    _drawArea(canvas, chartH, chartW, calNorm, const Color(0xFF3B82F6));
    _drawLine(canvas, chartH, chartW, calNorm, const Color(0xFF3B82F6), 2.2);
    _drawLine(canvas, chartH, chartW, workNorm, const Color(0xFF10B981), 2.0);
    _drawLine(canvas, chartH, chartW, wtNorm, const Color(0xFF8B5CF6), 2.0);

    // Small dots at all data entry points (hollow look)
    for (int i = 0; i < n; i++) {
      if (i == selectedIdx) continue;
      _drawSmallDot(
        canvas,
        chartH,
        chartW,
        i,
        calNorm[i],
        const Color(0xFF3B82F6),
      );
      _drawSmallDot(
        canvas,
        chartH,
        chartW,
        i,
        workNorm[i],
        const Color(0xFF10B981),
      );
      _drawSmallDot(
        canvas,
        chartH,
        chartW,
        i,
        wtNorm[i],
        const Color(0xFF8B5CF6),
      );
    }

    _drawVLine(canvas, chartH, chartW);
    _drawBigDot(
      canvas,
      chartH,
      chartW,
      calNorm[selectedIdx],
      const Color(0xFF3B82F6),
    );
    _drawBigDot(
      canvas,
      chartH,
      chartW,
      workNorm[selectedIdx],
      const Color(0xFF10B981),
    );
    _drawBigDot(
      canvas,
      chartH,
      chartW,
      wtNorm[selectedIdx],
      const Color(0xFF8B5CF6),
    );
    _drawXLabels(canvas, size, chartH, chartW);
  }

  List<double> _normSeries(double Function(_ChartPoint) fn) {
    final vals = points.map(fn).toList();
    final mn = vals.reduce(math.min);
    final mx = vals.reduce(math.max);
    if (mx == mn) return vals.map((_) => 0.5).toList();
    return vals.map((v) => (v - mn) / (mx - mn)).toList();
  }

  double _xAt(int i, double chartW) => leftPad + points[i].xNorm * chartW;
  double _yAt(double norm, double chartH) => topPad + chartH * (1 - norm);

  void _drawYAxis(Canvas canvas, Size size, double chartH, double chartW) {
    final calVals = points.map((p) => p.calValue).toList();
    final calMin = calVals.reduce(math.min);
    final calMax = calVals.reduce(math.max);

    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(
        alpha: isDark ? 0.07 : 0.09,
      )
      ..strokeWidth = 0.7;
    final axisPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(
        alpha: isDark ? 0.18 : 0.22,
      )
      ..strokeWidth = 1;
    final labelStyle = TextStyle(
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.42),
      fontSize: 9,
      fontWeight: FontWeight.w600,
    );

    const steps = 3;
    for (int i = 0; i <= steps; i++) {
      final y = topPad + chartH * i / steps;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(leftPad + chartW, y),
        gridPaint,
      );
      final val = calMax + (calMin - calMax) * i / steps;
      final str = val >= 1000
          ? '${(val / 1000).toStringAsFixed(1)}k'
          : val.toInt().toString();
      final tp = TextPainter(
        text: TextSpan(text: str, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPad - tp.width - 5, y - tp.height / 2));
    }
    // Y-axis line
    canvas.drawLine(
      Offset(leftPad, topPad),
      Offset(leftPad, topPad + chartH),
      axisPaint,
    );
  }

  void _drawArea(
    Canvas canvas,
    double chartH,
    double chartW,
    List<double> norm,
    Color color,
  ) {
    final path = _buildPath(norm, chartH, chartW);
    final fill = Path()
      ..addPath(path, Offset.zero)
      ..lineTo(_xAt(points.length - 1, chartW), topPad + chartH)
      ..lineTo(_xAt(0, chartW), topPad + chartH)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          colors: [color.withValues(alpha: 0.2), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(leftPad, topPad, chartW, chartH))
        ..style = PaintingStyle.fill,
    );
  }

  void _drawLine(
    Canvas canvas,
    double chartH,
    double chartW,
    List<double> norm,
    Color color,
    double strokeW,
  ) {
    canvas.drawPath(
      _buildPath(norm, chartH, chartW),
      Paint()
        ..color = color
        ..strokeWidth = strokeW
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  Path _buildPath(List<double> norm, double chartH, double chartW) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = _xAt(i, chartW);
      final y = _yAt(norm[i], chartH);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final px = _xAt(i - 1, chartW);
        final py = _yAt(norm[i - 1], chartH);
        final cx = (px + x) / 2;
        path.cubicTo(cx, py, cx, y, x, y);
      }
    }
    return path;
  }

  void _drawVLine(Canvas canvas, double chartH, double chartW) {
    final x = _xAt(selectedIdx, chartW);
    canvas.drawLine(
      Offset(x, topPad),
      Offset(x, topPad + chartH),
      Paint()
        ..color = (isDark ? Colors.white : Colors.blueGrey).withValues(
          alpha: 0.35,
        )
        ..strokeWidth = 1.2,
    );
  }

  void _drawSmallDot(
    Canvas canvas,
    double chartH,
    double chartW,
    int i,
    double norm,
    Color color,
  ) {
    final x = _xAt(i, chartW);
    final y = _yAt(norm, chartH);
    canvas.drawCircle(
      Offset(x, y),
      3.5,
      Paint()..color = color.withValues(alpha: 0.35),
    );
    canvas.drawCircle(Offset(x, y), 2, Paint()..color = color);
  }

  void _drawBigDot(
    Canvas canvas,
    double chartH,
    double chartW,
    double norm,
    Color color,
  ) {
    final x = _xAt(selectedIdx, chartW);
    final y = _yAt(norm, chartH);
    canvas.drawCircle(
      Offset(x, y),
      10,
      Paint()..color = color.withValues(alpha: 0.18),
    );
    canvas.drawCircle(Offset(x, y), 6, Paint()..color = color);
    canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);
  }

  void _drawXLabels(Canvas canvas, Size size, double chartH, double chartW) {
    for (int i = 0; i < points.length; i++) {
      final isSelected = i == selectedIdx;
      final label = points[i].label;
      if (label.isEmpty) continue;

      final x = _xAt(i, chartW);
      final y = size.height - botPad + 6;

      if (isSelected) {
        final style = const TextStyle(
          color: Colors.white,
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
        );
        final tp = TextPainter(
          text: TextSpan(text: label, style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        final bgRect = Rect.fromCenter(
          center: Offset(x, y + tp.height / 2),
          width: tp.width + 12,
          height: tp.height + 6,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(bgRect, const Radius.circular(8)),
          Paint()..color = const Color(0xFF3B82F6),
        );
        tp.paint(canvas, Offset(x - tp.width / 2, y));
      } else {
        final style = TextStyle(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        );
        final tp = TextPainter(
          text: TextSpan(text: label, style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y));
      }
    }
  }

  @override
  bool shouldRepaint(_MultiLinePainter old) =>
      old.selectedIdx != selectedIdx ||
      old.isDark != isDark ||
      old.points != points;
}

// ─────────────────────────────────────────────────────────────
// SMALL COMPONENTS
// ─────────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selected,
    required this.isDark,
    required this.onChanged,
  });
  final _Period selected;
  final bool isDark;
  final ValueChanged<_Period> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const labels = {
      _Period.week: 'Week',
      _Period.month: 'Month',
      _Period.year: 'Year',
    };
    return Center(
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1A2E) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _Period.values.map((p) {
            final sel = selected == p;
            return GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: sel
                      ? (isDark ? const Color(0xFF1E2E54) : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: sel && !isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  labels[p]!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                    color: sel
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(this.label, this.value, this.color);
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// OVERVIEW COMPONENTS
// ─────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B39BC), Color(0xFF08194F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B39BC).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      'ACTIVE STREAK',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '5 Days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(7, (i) {
                    final active = i < 5;
                    return Container(
                      margin: const EdgeInsets.only(right: 5),
                      width: 26,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF06B6D4)
                            : Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  'Burning 15% more than last week!',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.72,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF06B6D4),
                  ),
                  strokeCap: StrokeCap.round,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '72%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Goal',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tiles = [
      _KpiData(
        'Steps',
        '9,350',
        'today',
        Icons.directions_walk_rounded,
        isDark ? AppColors.stepsDark : AppColors.stepsLight,
      ),
      _KpiData(
        'Calories',
        '2,680',
        'kcal',
        Icons.local_fire_department_rounded,
        isDark ? AppColors.burnedDark : AppColors.burnedLight,
      ),
      _KpiData(
        'Workouts',
        '5',
        'this week',
        Icons.fitness_center_rounded,
        isDark ? AppColors.neonViolet : AppColors.fatLight,
      ),
      _KpiData(
        'Active',
        '3.5',
        'hours',
        Icons.timer_rounded,
        isDark ? AppColors.neonEmerald : AppColors.activeLight,
      ),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.55,
      children: tiles.map((t) => _KpiTile(data: t)).toList(),
    );
  }
}

class _KpiData {
  const _KpiData(this.title, this.value, this.unit, this.icon, this.color);
  final String title, value, unit;
  final IconData icon;
  final Color color;
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.data});
  final _KpiData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, color: data.color, size: 14),
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.unit,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final macros = [
      _MacroItem(
        'Calories',
        1840,
        2200,
        isDark ? AppColors.caloriesDark : AppColors.caloriesLight,
        AppGradients.caloriesProgress,
      ),
      _MacroItem(
        'Protein',
        98,
        130,
        isDark ? AppColors.proteinDark : AppColors.proteinLight,
        AppGradients.proteinProgress,
      ),
      _MacroItem(
        'Carbs',
        175,
        250,
        isDark ? AppColors.carbsDark : AppColors.carbsLight,
        AppGradients.carbsProgress,
      ),
      _MacroItem(
        'Fat',
        52,
        70,
        isDark ? AppColors.fatDark : AppColors.fatLight,
        AppGradients.fatProgress,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: macros.asMap().entries.map((entry) {
          final i = entry.key;
          final m = entry.value;
          final ratio = (m.current / m.target).clamp(0.0, 1.0);
          return Padding(
            padding: EdgeInsets.only(bottom: i < macros.length - 1 ? 14 : 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: m.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          m.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${m.current} / ${m.target}${m.name == 'Calories' ? ' kcal' : ' g'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Container(
                    height: 7,
                    color: m.color.withValues(alpha: 0.12),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: ratio,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: m.gradient,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MacroItem {
  const _MacroItem(
    this.name,
    this.current,
    this.target,
    this.color,
    this.gradient,
  );
  final String name;
  final int current, target;
  final Color color;
  final LinearGradient gradient;
}

class _MonthlyHighlightCard extends StatelessWidget {
  const _MonthlyHighlightCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'August 2026 Summary',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MonthlyStat(
                '18',
                'Workouts',
                Icons.fitness_center_rounded,
                AppColors.primaryBlue,
              ),
              _vDiv(),
              _MonthlyStat(
                '87k',
                'Steps',
                Icons.directions_walk_rounded,
                isDark ? AppColors.stepsDark : AppColors.stepsLight,
              ),
              _vDiv(),
              _MonthlyStat(
                '12,400',
                'Kcal',
                Icons.local_fire_department_rounded,
                isDark ? AppColors.burnedDark : AppColors.burnedLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vDiv() => Container(
    width: 1,
    height: 40,
    color: Colors.white.withValues(alpha: 0.1),
  );
}

class _MonthlyStat extends StatelessWidget {
  const _MonthlyStat(this.value, this.label, this.icon, this.color);
  final String value, label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _SimpleChartCard extends StatelessWidget {
  const _SimpleChartCard({required this.isDark, required this.child});
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
      ),
      child: SizedBox(height: 160, child: child),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({
    required this.values,
    required this.labels,
    required this.maxValue,
    required this.gradient,
  });
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (i) {
        final ratio = (values[i] / maxValue).clamp(0.0, 1.0);
        final h = 100.0 * ratio;
        final str = values[i] >= 1000
            ? '${(values[i] / 1000).toStringAsFixed(1)}k'
            : '${values[i].toInt()}';
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              str,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 16,
              height: h.clamp(6.0, 100.0),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.last.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              labels[i],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _MuscleBreakdownCard extends StatelessWidget {
  const _MuscleBreakdownCard({required this.isDark, required this.data});
  final bool isDark;
  final List<Map<String, Object>> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: data.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final pct = item['pct'] as double;
          final color = item['color'] as Color;
          final label = item['label'] as String;
          final icon = item['icon'] as String;
          return Padding(
            padding: EdgeInsets.only(bottom: i < data.length - 1 ? 14 : 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 15)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      '${(pct * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: Container(
                    height: 7,
                    color: color.withValues(alpha: 0.12),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: pct,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(99),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.35),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ConsistencyGrid extends StatelessWidget {
  const _ConsistencyGrid({required this.isDark});
  final bool isDark;

  static const _grid = [
    [true, true, false, true, true, true, false],
    [true, false, true, true, true, false, false],
    [false, true, true, true, false, true, true],
    [true, true, false, true, true, false, true],
  ];
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _weeks = ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const activeColor = Color(0xFF3B82F6);
    final inactiveColor = theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient(theme.brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : theme.colorScheme.outline.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 44),
              ..._days.map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.45,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(
            4,
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(
                      _weeks[w],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.45,
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(7, (d) {
                    final trained = _grid[w][d];
                    return Expanded(
                      child: Center(
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: trained
                                ? activeColor.withValues(
                                    alpha: isDark ? 0.8 : 0.75,
                                  )
                                : inactiveColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: trained && isDark
                                ? [
                                    BoxShadow(
                                      color: activeColor.withValues(alpha: 0.3),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : [],
                          ),
                          child: trained
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 13,
                                  color: Colors.white.withValues(alpha: 0.95),
                                )
                              : null,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Trained',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: inactiveColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Rest',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
