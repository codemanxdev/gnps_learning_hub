import 'dart:math';
import 'package:flutter/material.dart';

/// Draws an illustrated forest scene behind the lesson path: a soft green
/// gradient, a hand-worn dirt trail with grass fraying its edges, ambient
/// grass tufts scattered across the whole ground, dense scattered
/// trees/bushes/leaf-litter on either side, and clusters of stones and
/// pebbles piled toward the outside of each bend in the trail.
///
/// Scenery bands are computed relative to the path's *local* x position
/// at each row (interpolated from pathPoints), not a fixed global center —
/// so trees hug the path's actual curve as it winds left/right, rather
/// than sometimes ending up implausibly far from (or overlapping) the
/// trail depending on how far the wave has swung at that height.
class ForestBackgroundPainter extends CustomPainter {
  final List<Offset> pathPoints;
  final double centerX;
  final double pathClearance;

  ForestBackgroundPainter({
    required this.pathPoints,
    required this.centerX,
    this.pathClearance = 65, // reduced — lets trees sit closer to the trail
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintTrail(canvas);
    _paintCornerStones(canvas);
    _paintScenery(canvas, size);
  }

  void _paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEBF7E4), Color(0xFFD5EEC2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, gradientPaint);
  }

  /// The path's x position at a given y, linearly interpolated between
  /// the two surrounding pathPoints.
  double _pathXAt(double y) {
    if (pathPoints.isEmpty) return centerX;
    if (pathPoints.length == 1) return pathPoints.first.dx;
    if (y <= pathPoints.first.dy) return pathPoints.first.dx;
    if (y >= pathPoints.last.dy) return pathPoints.last.dx;

    for (int i = 0; i < pathPoints.length - 1; i++) {
      final a = pathPoints[i];
      final b = pathPoints[i + 1];
      if (y >= a.dy && y <= b.dy) {
        final t = (y - a.dy) / (b.dy - a.dy);
        return a.dx + (b.dx - a.dx) * t;
      }
    }
    return centerX;
  }

  void _paintTrail(Canvas canvas) {
    if (pathPoints.length < 2) return;
    final random = Random(11);

    for (int i = 0; i < pathPoints.length - 1; i++) {
      final start = pathPoints[i];
      final end = pathPoints[i + 1];
      const segments = 6;

      for (int s = 0; s < segments; s++) {
        final t0 = s / segments;
        final t1 = (s + 1) / segments;
        final p0 = Offset.lerp(start, end, t0)!;
        final p1 = Offset.lerp(start, end, t1)!;

        final width = 42 + random.nextDouble() * 16;
        final colorMix = random.nextDouble();
        final trailPaint = Paint()
          ..color = Color.lerp(
            const Color(0xFFDCC49A),
            const Color(0xFFC9AF7C),
            colorMix,
          )!.withValues(alpha: 0.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(p0, p1, trailPaint);
      }

      for (int j = 0; j < 4; j++) {
        final t = random.nextDouble();
        final base = Offset.lerp(start, end, t)!;
        final jitter = Offset(
          (random.nextDouble() - 0.5) * 30,
          (random.nextDouble() - 0.5) * 10,
        );
        final point = base + jitter;

        if (random.nextBool()) {
          final pebblePaint = Paint()
            ..color = const Color(0xFFAFA089).withValues(alpha: 0.8);
          canvas.drawCircle(point, 2.5 + random.nextDouble() * 2, pebblePaint);
        } else {
          _paintLeafLitter(canvas, point, random);
        }
      }

      for (int j = 0; j < 7; j++) {
        final t = random.nextDouble();
        final base = Offset.lerp(start, end, t)!;
        final side = random.nextBool() ? -1 : 1;
        final edgeOffset = Offset(side * (24 + random.nextDouble() * 14), 0);
        _paintGrassTuft(canvas, base + edgeOffset, random);
      }
    }
  }

  /// Scatters clusters of stones and pebbles at each bend of the trail,
  /// biased toward the outside (convex side) of the curve — the way loose
  /// debris naturally piles up on the outer edge of a winding path.
  void _paintCornerStones(Canvas canvas) {
    if (pathPoints.length < 2) return;
    final random = Random(29);

    for (int i = 0; i < pathPoints.length; i++) {
      final point = pathPoints[i];

      // Estimate which side this bend curves toward, so stones land on
      // the outer edge rather than scattered evenly across the trail.
      double bendDir;
      if (i > 0 && i < pathPoints.length - 1) {
        final prev = pathPoints[i - 1];
        final next = pathPoints[i + 1];
        bendDir = (point.dx - prev.dx) - (next.dx - point.dx);
      } else if (i == 0) {
        bendDir = point.dx - pathPoints[1].dx;
      } else {
        bendDir = point.dx - pathPoints[i - 1].dx;
      }
      final side = bendDir >= 0 ? 1 : -1;

      final stoneCount = 5 + random.nextInt(4); // 5-8 per bend
      for (int s = 0; s < stoneCount; s++) {
        final along = (random.nextDouble() - 0.5) * 60;
        final across = side * (28 + random.nextDouble() * 42);
        final stonePoint = point + Offset(across, along);
        final radius = 3 + random.nextDouble() * 5.5;
        _paintStone(canvas, stonePoint, radius, random);
      }

      // A couple of loose pebbles drifted toward the inner edge too, so
      // the cluster doesn't look perfectly one-sided.
      for (int s = 0; s < 2; s++) {
        final along = (random.nextDouble() - 0.5) * 40;
        final across = -side * (10 + random.nextDouble() * 20);
        final pebblePoint = point + Offset(across, along);
        canvas.drawCircle(
          pebblePoint,
          2 + random.nextDouble() * 2,
          Paint()..color = const Color(0xFFAFA089).withValues(alpha: 0.8),
        );
      }
    }
  }

  /// A single irregular, lightly shaded stone (rougher and more varied
  /// than the small round trail pebbles).
  void _paintStone(Canvas canvas, Offset center, double radius, Random random) {
    const baseColors = [
      Color(0xFF9C9284),
      Color(0xFFA8A296),
      Color(0xFF8A8175),
      Color(0xFFB0AA9C),
    ];
    final base = baseColors[random.nextInt(baseColors.length)];

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(random.nextDouble() * pi);

    final path = Path();
    const sides = 7;
    for (int p = 0; p < sides; p++) {
      final angle = (p / sides) * 2 * pi;
      final r = radius * (0.8 + random.nextDouble() * 0.35);
      final x = cos(angle) * r;
      final y = sin(angle) * r * 0.85; // slightly flattened, more stone-like
      if (p == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = base.withValues(alpha: 0.9));
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF5F594E).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Small highlight for a touch of dimensionality.
    canvas.drawCircle(
      Offset(-radius * 0.25, -radius * 0.25),
      radius * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    canvas.restore();
  }

  static const _leafLitterColors = [
    Color(0xFFB5883D),
    Color(0xFFD99A3E),
    Color(0xFFC96A3D),
    Color(0xFF8FAE5C),
  ];

  void _paintLeafLitter(Canvas canvas, Offset point, Random random) {
    final paint = Paint()
      ..color = _leafLitterColors[random.nextInt(_leafLitterColors.length)]
          .withValues(alpha: 0.75);
    canvas.save();
    canvas.translate(point.dx, point.dy);
    canvas.rotate(random.nextDouble() * pi);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 7, height: 4),
      paint,
    );
    canvas.restore();
  }

  void _paintGrassTuft(Canvas canvas, Offset base, Random random) {
    final paint = Paint()
      ..color = const Color(0xFF6FA85C).withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int blade = 0; blade < 3; blade++) {
      final angle =
          -pi / 2 + (blade - 1) * 0.4 + (random.nextDouble() - 0.5) * 0.2;
      final length = 8 + random.nextDouble() * 7;
      final tip = base + Offset(cos(angle), sin(angle)) * length;
      canvas.drawLine(base, tip, paint);
    }
  }

  void _paintScenery(Canvas canvas, Size size) {
    final random = Random(7);
    const verticalStep = 38.0;

    for (double y = 6; y < size.height; y += verticalStep) {
      final localX = _pathXAt(y);
      final leftBandMax = (localX - pathClearance).clamp(20.0, size.width);
      final rightBandMin = (localX + pathClearance).clamp(0.0, size.width - 20);

      if (random.nextDouble() < 0.95 && leftBandMax > 30) {
        final x = random.nextDouble() * (leftBandMax - 30) + 10;
        _paintTreeOrBush(
          canvas,
          Offset(x, y + random.nextDouble() * 25),
          random,
        );
      }
      if (random.nextDouble() < 0.95 && rightBandMin < size.width - 30) {
        final x =
            rightBandMin +
            random.nextDouble() * (size.width - rightBandMin - 30);
        _paintTreeOrBush(
          canvas,
          Offset(x, y + random.nextDouble() * 25),
          random,
        );
      }

      if (random.nextDouble() < 0.5 && leftBandMax > 30) {
        final x = random.nextDouble() * (leftBandMax - 30) + 10;
        _paintBush(
          canvas,
          Offset(x, y + 20 + random.nextDouble() * 15),
          14 + random.nextDouble() * 6,
        );
      }
      if (random.nextDouble() < 0.5 && rightBandMin < size.width - 30) {
        final x =
            rightBandMin +
            random.nextDouble() * (size.width - rightBandMin - 30);
        _paintBush(
          canvas,
          Offset(x, y + 20 + random.nextDouble() * 15),
          14 + random.nextDouble() * 6,
        );
      }

      for (int g = 0; g < 3; g++) {
        if (random.nextDouble() < 0.7 && leftBandMax > 30) {
          final x = random.nextDouble() * (leftBandMax - 20) + 10;
          _paintGrassTuft(
            canvas,
            Offset(x, y + random.nextDouble() * verticalStep),
            random,
          );
        }
        if (random.nextDouble() < 0.7 && rightBandMin < size.width - 30) {
          final x =
              rightBandMin +
              random.nextDouble() * (size.width - rightBandMin - 20);
          _paintGrassTuft(
            canvas,
            Offset(x, y + random.nextDouble() * verticalStep),
            random,
          );
        }
      }

      if (random.nextDouble() < 0.6) {
        final onLeft = random.nextBool();
        final x = onLeft
            ? random.nextDouble() * (leftBandMax - 20) + 10
            : rightBandMin +
                  random.nextDouble() * (size.width - rightBandMin - 20);
        for (int l = 0; l < 3; l++) {
          _paintLeafLitter(
            canvas,
            Offset(
              x + (random.nextDouble() - 0.5) * 18,
              y + (random.nextDouble() - 0.5) * 18,
            ),
            random,
          );
        }
      }
    }
  }

  void _paintTreeOrBush(Canvas canvas, Offset base, Random random) {
    final isBush = random.nextDouble() < 0.35;
    if (isBush) {
      _paintBush(canvas, base, 18 + random.nextDouble() * 10);
    } else {
      _paintTree(canvas, base, 24 + random.nextDouble() * 18);
    }
  }

  void _paintTree(Canvas canvas, Offset base, double foliageRadius) {
    final trunkPaint = Paint()..color = const Color(0xFF8B6A4A);
    final trunkRect = Rect.fromCenter(
      center: Offset(base.dx, base.dy + foliageRadius * 0.6),
      width: foliageRadius * 0.35,
      height: foliageRadius * 1.1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(trunkRect, const Radius.circular(3)),
      trunkPaint,
    );

    final foliageColors = [
      const Color(0xFF6FA85C),
      const Color(0xFF5C9650),
      const Color(0xFF80B86A),
      const Color(0xFF4F8A45),
    ];
    for (int i = 0; i < 4; i++) {
      final paint = Paint()..color = foliageColors[i % foliageColors.length];
      final offset = Offset(
        base.dx + (i - 1.5) * foliageRadius * 0.3,
        base.dy - foliageRadius * 0.3 - i * foliageRadius * 0.12,
      );
      canvas.drawCircle(offset, foliageRadius * (1 - i * 0.1), paint);
    }
  }

  void _paintBush(Canvas canvas, Offset base, double radius) {
    final colors = [const Color(0xFF7BB566), const Color(0xFF669C55)];
    for (int i = 0; i < 3; i++) {
      final paint = Paint()..color = colors[i % colors.length];
      final offset = Offset(base.dx + (i - 1) * radius * 0.6, base.dy);
      canvas.drawCircle(offset, radius * 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ForestBackgroundPainter oldDelegate) =>
      oldDelegate.pathPoints != pathPoints || oldDelegate.centerX != centerX;
}
