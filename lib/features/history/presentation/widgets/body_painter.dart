import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_drawing/path_drawing.dart';

import '../../models/muscle_rank_models.dart';

/// Which side of the body to render.
enum BodyView { front, back }

// Map tier to color, allowing for 'none' as well
Color getTierColor(MuscleRankTier? tier) {
  if (tier == null) return const Color(0xFF3A3A45); // unfilled / no data
  return tier.color;
}

/// Loads front_muscles.json / back_muscles.json from assets/body/ and
/// parses each muscle's SVG path strings into Flutter Path objects.
class MuscleAtlas {
  final BodyView view;
  /// slug -> list of parsed sub-paths (a muscle can be split into several
  /// disjoint shapes, e.g. left obliques has 5 separate blobs).
  final Map<String, List<Path>> muscles;
  final Size sourceSize;

  MuscleAtlas({required this.view, required this.muscles, required this.sourceSize});

  static Future<MuscleAtlas> load(BodyView view) async {
    final file = view == BodyView.front
        ? 'assets/body/front_muscles.json'
        : 'assets/body/back_muscles.json';
    final raw = await rootBundle.loadString(file);
    final Map<String, dynamic> data = jsonDecode(raw);

    final muscles = <String, List<Path>>{};
    for (final entry in data.entries) {
      final slug = entry.key;
      final List parts = entry.value; // [{side: "left", d: "M..."}, ...]
      muscles[slug] = parts
          .map<Path>((p) => parseSvgPathData(p['d'] as String))
          .toList();
    }

    // Original artwork viewBox: 724x1448 per side.
    // The figure spans Y=290 to Y=1340. We crop with 20px padding:
    return MuscleAtlas(view: view, muscles: muscles, sourceSize: const Size(724, 1120));
  }
}

/// Paints a MuscleAtlas, scaling the original 724x1448 coordinate space to
/// fit the widget, and filling each muscle group by its tier color.
class BodyMapPainter extends CustomPainter {
  final MuscleAtlas atlas;
  final Map<String, MuscleRankTier> muscleTiers; // slug -> tier
  final String? highlightedSlug; // slug currently tapped/hovered, or null

  BodyMapPainter({
    required this.atlas,
    required this.muscleTiers,
    this.highlightedSlug,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / atlas.sourceSize.width;
    final scaleY = size.height / atlas.sourceSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    canvas.save();
    canvas.scale(scale);
    
    // The back muscles SVG coordinates start at X=724.
    // Translate Y by -240 to crop empty space but keep the neck intact.
    if (atlas.view == BodyView.back) {
      canvas.translate(-724.0, -240.0);
    } else {
      canvas.translate(0.0, -240.0);
    }

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.black.withOpacity(0.25);

    atlas.muscles.forEach((slug, paths) {
      final tier = muscleTiers[slug];
      fillPaint.color = getTierColor(tier);

      if (slug == highlightedSlug) {
        fillPaint.color = fillPaint.color.withOpacity(1.0);
        strokePaint.color = Colors.white.withOpacity(0.9);
        strokePaint.strokeWidth = 2.0;
      } else {
        strokePaint.color = Colors.black.withOpacity(0.25);
        strokePaint.strokeWidth = 1.2;
      }

      for (final path in paths) {
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, strokePaint);
      }
    });

    canvas.restore();
  }

  /// Hit-tests a tap point (in widget-local coordinates) against every
  /// muscle's paths and returns the slug that was hit, or null.
  String? getHitMuscleSlug(Offset localPosition, Size widgetSize) {
    final scaleX = widgetSize.width / atlas.sourceSize.width;
    final scaleY = widgetSize.height / atlas.sourceSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    
    double px = localPosition.dx / scale;
    double py = localPosition.dy / scale;
    
    if (atlas.view == BodyView.back) {
      px += 724.0;
    }
    py += 270.0; // reverse the Y crop translation
    
    final p = Offset(px, py);

    for (final entry in atlas.muscles.entries) {
      for (final path in entry.value) {
        if (path.contains(p)) return entry.key;
      }
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant BodyMapPainter oldDelegate) {
    return oldDelegate.muscleTiers != muscleTiers ||
        oldDelegate.highlightedSlug != highlightedSlug;
  }
}

/// Ready-to-use widget: loads the atlas, renders it, and reports taps.
class BodyMapView extends StatefulWidget {
  final BodyView view;
  final Map<String, MuscleRankTier> muscleTiers;
  final ValueChanged<String>? onMuscleTap;

  const BodyMapView({
    super.key,
    required this.view,
    required this.muscleTiers,
    this.onMuscleTap,
  });

  @override
  State<BodyMapView> createState() => _BodyMapViewState();
}

class _BodyMapViewState extends State<BodyMapView> {
  MuscleAtlas? _atlas;
  String? _highlighted;

  @override
  void initState() {
    super.initState();
    MuscleAtlas.load(widget.view).then((a) => setState(() => _atlas = a));
  }

  @override
  void didUpdateWidget(covariant BodyMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view != widget.view) {
      MuscleAtlas.load(widget.view).then((a) => setState(() => _atlas = a));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_atlas == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final painter = BodyMapPainter(
      atlas: _atlas!,
      muscleTiers: widget.muscleTiers,
      highlightedSlug: _highlighted,
    );
    return AspectRatio(
      aspectRatio: _atlas!.sourceSize.width / _atlas!.sourceSize.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onTapUp: (details) {
              final slug = painter.getHitMuscleSlug(details.localPosition, size);
              setState(() => _highlighted = slug);
              if (slug != null) widget.onMuscleTap?.call(slug);
            },
            child: CustomPaint(painter: painter, size: size),
          );
        },
      ),
    );
  }
}
