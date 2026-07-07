import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../common/task_speaker_button.dart';
import '../common/task_done_button.dart';
import '../common/task_clear_button.dart';
import '../common/task_header.dart';

/// Lets the child trace a letter over a guide.
///
/// NOTE: this used to be deliberately non-validating (muscle-memory practice
/// only, always advances on "Done" — see prior product spec). Per updated
/// requirements this now *does* fail the attempt: strokes drawn too far off
/// the letter's shape are rejected in real time, and "Done" only unlocks
/// once enough of the letter has actually been traced.
class TraceTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;

  const TraceTaskWidget({
    super.key,
    required this.task,
    required this.onComplete,
  });

  @override
  ConsumerState<TraceTaskWidget> createState() => _TraceTaskWidgetState();
}

class _TraceTaskWidgetState extends ConsumerState<TraceTaskWidget> {
  // --- Tunable validation constants ---
  static const double _onTrackTolerance =
      16; // px a stroke point may sit off the letter's ink and still count
  static const double _coverageSampleStep =
      6; // grid spacing when scanning the letter for ink pixels
  static const double _coverageHitRadius =
      12; // how close a stroke point must get to "cover" a sample
  static const double _requiredCoverage =
      0.55; // fraction of the letter that must be traced to pass
  static const int _alphaThreshold = 40; // min alpha to count a pixel as "ink"

  final List<Offset> _points = [];

  Size? _maskSize;
  String? _maskLetter;
  ByteData? _letterMask;
  List<Offset> _inkSamples = [];
  final Set<int> _coveredSampleIndices = {};

  bool _failed = false;
  bool _isBuildingMask = false;

  double get _coverageRatio => _inkSamples.isEmpty
      ? 0
      : _coveredSampleIndices.length / _inkSamples.length;

  bool get _canComplete => !_failed && _coverageRatio >= _requiredCoverage;

  Future<void> _ensureMask(Size size, String letter) async {
    if (_isBuildingMask) return;
    if (_maskSize == size && _maskLetter == letter && _letterMask != null) {
      return;
    }
    _isBuildingMask = true;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.7,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final width = size.width.round().clamp(1, 4000);
    final height = size.height.round().clamp(1, 4000);
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();

    if (!mounted || byteData == null) {
      _isBuildingMask = false;
      return;
    }

    final samples = <Offset>[];
    for (double y = 0; y < height; y += _coverageSampleStep) {
      for (double x = 0; x < width; x += _coverageSampleStep) {
        if (_alphaAt(byteData, width, height, x, y) > _alphaThreshold) {
          samples.add(Offset(x, y));
        }
      }
    }

    setState(() {
      _maskSize = size;
      _maskLetter = letter;
      _letterMask = byteData;
      _inkSamples = samples;
      _coveredSampleIndices.clear();
      _isBuildingMask = false;
    });
  }

  int _alphaAt(ByteData data, int width, int height, double x, double y) {
    final ix = x.round().clamp(0, width - 1);
    final iy = y.round().clamp(0, height - 1);
    final index = (iy * width + ix) * 4;
    if (index + 3 >= data.lengthInBytes) return 0;
    return data.getUint8(index + 3); // alpha channel
  }

  /// Whether [point] sits on (or within tolerance of) the letter's ink.
  /// Checks a small ring around the point rather than just the exact pixel,
  /// so strokes near a thick edge of the letter aren't unfairly rejected.
  bool _isOnLetter(Offset point) {
    final mask = _letterMask;
    final size = _maskSize;
    if (mask == null || size == null) {
      return true; // mask not ready yet — don't block the user
    }
    final width = size.width.round();
    final height = size.height.round();

    if (_alphaAt(mask, width, height, point.dx, point.dy) > _alphaThreshold) {
      return true;
    }

    const ringSteps = 8;
    for (int i = 0; i < ringSteps; i++) {
      final angle = (i / ringSteps) * 2 * math.pi;
      final dx = point.dx + _onTrackTolerance * math.cos(angle);
      final dy = point.dy + _onTrackTolerance * math.sin(angle);
      if (_alphaAt(mask, width, height, dx, dy) > _alphaThreshold) return true;
    }
    return false;
  }

  void _updateCoverage(Offset point) {
    final hitRadiusSq = _coverageHitRadius * _coverageHitRadius;
    for (int i = 0; i < _inkSamples.length; i++) {
      if (_coveredSampleIndices.contains(i)) continue;
      final sample = _inkSamples[i];
      final dx = sample.dx - point.dx;
      final dy = sample.dy - point.dy;
      if (dx * dx + dy * dy <= hitRadiusSq) {
        _coveredSampleIndices.add(i);
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_failed) {
      return; // ignore further input until the child clears and retries
    }
    final point = details.localPosition;
    final onLetter = _isOnLetter(point);

    setState(() {
      _points.add(point);
      if (!onLetter) {
        _failed = true;
      } else {
        _updateCoverage(point);
      }
    });

    if (!onLetter) {
      HapticFeedback.mediumImpact();
    }
  }

  void _clear() {
    setState(() {
      _points.clear();
      _failed = false;
      _coveredSampleIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.task.content['letter'] as String;
    final transliteration =
        widget.task.content['transliteration'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const TaskHeader(title: 'Trace the letter'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TaskSpeakerButton(textToSpeak: letter),
              const SizedBox(width: 8),
              Text(
                transliteration,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                if (size.isFinite) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _ensureMask(size, letter),
                  );
                }
                return GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: (_) => setState(() => _points.add(Offset.infinite)),
                  // pen lift marker
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _failed ? Colors.red : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomPaint(
                      painter: _TracePainter(
                        letter: letter,
                        points: _points,
                        failed: _failed,
                      ),
                      size: size,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _failed
                ? 'Off the letter — tap Clear and try again'
                : _canComplete
                ? 'Nicely traced! Tap Done.'
                : 'Keep tracing the whole letter (${(_coverageRatio * 100).round()}%)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _failed
                  ? Colors.red
                  : _canComplete
                  ? Colors.green.shade700
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TaskClearButton(onPressed: _clear),
              const Spacer(),
              TaskDoneButton(
                onPressed: _canComplete ? widget.onComplete : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  final String letter;
  final List<Offset> points;
  final bool failed;

  _TracePainter({
    required this.letter,
    required this.points,
    required this.failed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Faint guide letter in the background.
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.7,
          color: Colors.grey.withValues(alpha: 0.25),
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // User's traced strokes — red once the attempt has failed.
    final strokePaint = Paint()
      ..color = failed ? Colors.red : Colors.blue
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] == Offset.infinite || points[i + 1] == Offset.infinite) {
        continue;
      }
      canvas.drawLine(points[i], points[i + 1], strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
