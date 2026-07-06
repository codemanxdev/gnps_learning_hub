import 'dart:math';
import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import './props/flying_butterfly.dart';
import './props/firefly_sparkle.dart';
import './props/floating_leaf.dart';
import './props/flying_bird.dart';
import 'forest_background_painter.dart';
import './props/hopping_squirrel.dart';
import 'lesson_node.dart';

class LessonPath extends StatelessWidget {
  final List<Lesson> lessons;
  final Set<String> unlockedIds;
  final Set<String> completedIds;
  final void Function(Lesson lesson) onTapLesson;

  static const double _verticalSpacing = 150;
  static const double _nodeSize = 76;
  static const double _horizontalAmplitude = 90;
  static const double _topPadding = 70;

  const LessonPath({
    super.key,
    required this.lessons,
    required this.unlockedIds,
    required this.completedIds,
    required this.onTapLesson,
  });

  String? get _currentLessonId {
    for (final lesson in lessons) {
      if (unlockedIds.contains(lesson.id) &&
          !completedIds.contains(lesson.id)) {
        return lesson.id;
      }
    }
    return null;
  }

  LessonNodeState _stateFor(Lesson lesson) {
    if (completedIds.contains(lesson.id)) return LessonNodeState.completed;
    if (lesson.id == _currentLessonId) return LessonNodeState.current;
    if (unlockedIds.contains(lesson.id)) return LessonNodeState.unlocked;
    return LessonNodeState.locked;
  }

  double _xOffsetFor(int index, double centerX) {
    final wave = sin(index * pi / 2.2);
    return centerX + wave * _horizontalAmplitude;
  }

  List<Widget> _buildExtraLeaves(List<Offset> nodeCenters, double centerX) {
    final leaves = <Widget>[];
    final random = Random(41);

    for (int i = 0; i < nodeCenters.length - 1; i++) {
      final segmentTop = nodeCenters[i].dy;
      final segmentBottom = nodeCenters[i + 1].dy;

      for (int j = 0; j < 3; j++) {
        final y =
            segmentTop + (segmentBottom - segmentTop) * random.nextDouble();
        final side = random.nextBool() ? -1 : 1;
        final x = centerX + side * (60 + random.nextDouble() * 160);

        leaves.add(
          Positioned(
            left: x,
            top: y,
            child: FloatingLeaf(
              size: 16 + random.nextDouble() * 10,
              period: Duration(milliseconds: 2200 + random.nextInt(1600)),
            ),
          ),
        );
      }
    }
    return leaves;
  }

  List<Widget> _buildCreatures(List<Offset> nodeCenters, double centerX) {
    final decorations = <Widget>[];
    // No fixed seed: spawn positions now vary between app loads/rebuilds
    // instead of always landing in the exact same spots.
    final random = Random();

    for (int i = 0; i < nodeCenters.length - 1; i++) {
      final segmentTop = nodeCenters[i].dy;
      final segmentBottom = nodeCenters[i + 1].dy;

      for (int j = 0; j < 2; j++) {
        final y =
            segmentTop +
            (segmentBottom - segmentTop) * (0.15 + random.nextDouble() * 0.6);
        final side = random.nextBool() ? -1 : 1;

        // Default starting X for other props
        double x = centerX + side * (140 + random.nextDouble() * 60);

        final creatureIndex = (i * 2 + j) % 4;
        Widget creature;

        switch (creatureIndex) {
          case 0:
            creature = FloatingLeaf(
              period: Duration(milliseconds: 2600 + (i % 3) * 400),
            );
            break;

          case 1:
            // Spawn positions relative to map center
            if (side == 1) {
              x = centerX + 40 + random.nextDouble() * 20;
            } else {
              x = centerX - 120 - random.nextDouble() * 20;
            }

            const butterflySize = 2.0; // Tiny, elegant forest butterfly scale
            creature = SizedBox(
              width: butterflySize * 1.6,
              height: butterflySize,
              child: FlyingButterfly(
                travelWidth: 50,
                size: butterflySize,
                flyLeft:
                    side ==
                    1, // Instantly mirrors flight vector & paths properly
              ),
            );
            break;

          case 2:
            creature = HoppingSquirrel(
              period: Duration(milliseconds: 1200 + (i % 3) * 300),
            );
            break;

          default:
            creature = FireflySparkle(
              period: Duration(milliseconds: 1800 + (i % 3) * 400),
            );
        }

        decorations.add(Positioned(left: x, top: y, child: creature));
      }
    }
    return decorations;
  }

  List<Widget> _buildBirds(double totalHeight, double totalWidth) {
    final birds = <Widget>[];
    final birdCount = max(1, (totalHeight / 500).floor());
    for (int i = 0; i < birdCount; i++) {
      final y = totalHeight * (i + 0.5) / birdCount;
      birds.add(
        Positioned(
          left: -40,
          top: y,
          child: FlyingBird(
            travelWidth: totalWidth + 80,
            period: Duration(seconds: 9 + i * 2),
          ),
        ),
      );
    }
    return birds;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final totalHeight =
            _verticalSpacing * lessons.length + _nodeSize + _topPadding + 68;

        final nodeCenters = [
          for (int i = 0; i < lessons.length; i++)
            Offset(
              _xOffsetFor(i, centerX),
              i * _verticalSpacing + _nodeSize / 2 + _topPadding,
            ),
        ];

        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            height: totalHeight,
            child: Stack(
              clipBehavior: Clip.none,
              // Ensures layout elements glide naturally offscreen
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ForestBackgroundPainter(
                      pathPoints: nodeCenters,
                      centerX: centerX,
                    ),
                  ),
                ),
                ..._buildCreatures(nodeCenters, centerX),
                ..._buildExtraLeaves(nodeCenters, centerX),
                ..._buildBirds(totalHeight, constraints.maxWidth),
                for (int i = 0; i < lessons.length; i++)
                  Positioned(
                    left: nodeCenters[i].dx - (_nodeSize + 24) / 2,
                    top: nodeCenters[i].dy - _nodeSize / 2 - 44,
                    width: _nodeSize + 24,
                    child: LessonNode(
                      title: lessons[i].title,
                      state: _stateFor(lessons[i]),
                      size: _nodeSize,
                      onTap: unlockedIds.contains(lessons[i].id)
                          ? () => onTapLesson(lessons[i])
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
