import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers.dart';

/// Lets the child trace a letter freely over a faint guide. No correctness
/// validation — this is deliberate (see product spec): the goal is muscle
/// memory practice, not a pass/fail gate. Tapping "Done" always advances.
class TraceTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;

  const TraceTaskWidget({super.key, required this.task, required this.onComplete});

  @override
  ConsumerState<TraceTaskWidget> createState() => _TraceTaskWidgetState();
}

class _TraceTaskWidgetState extends ConsumerState<TraceTaskWidget> {
  final List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    final letter = widget.task.content['letter'] as String;
    final transliteration = widget.task.content['transliteration'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text('Trace the letter', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(transliteration, style: Theme.of(context).textTheme.bodyLarge),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => ref.read(audioServiceProvider).speak(letter),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) => setState(() => _points.add(details.localPosition)),
              onPanEnd: (_) => setState(() => _points.add(Offset.infinite)), // pen lift marker
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomPaint(
                  painter: _TracePainter(letter: letter, points: _points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => setState(() => _points.clear()),
                icon: const Icon(Icons.refresh),
                label: const Text('Clear'),
              ),
              const Spacer(),
              FilledButton(onPressed: widget.onComplete, child: const Text('Done')),
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

  _TracePainter({required this.letter, required this.points});

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
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );

    // User's traced strokes.
    final strokePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] == Offset.infinite || points[i + 1] == Offset.infinite) continue;
      canvas.drawLine(points[i], points[i + 1], strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
