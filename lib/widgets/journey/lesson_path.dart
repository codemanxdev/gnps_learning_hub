import 'dart:math';
import 'package:flutter/material.dart';

import '../../models/lesson.dart';
import 'dashed_path_painter.dart';
import 'lesson_node.dart';

class LessonPath extends StatelessWidget {
  final List<Lesson> lessons;
  final Set<String> unlockedIds;
  final Set<String> completedIds;
  final void Function(Lesson lesson) onTapLesson;

  static const double _verticalSpacing = 150;
  static const double _nodeSize = 76;
  static const double _horizontalAmplitude = 90;
  static const double _topPadding =
      70; // room for the START bubble above the first node

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerX = constraints.maxWidth / 2;
        final totalHeight =
            _verticalSpacing * lessons.length + _nodeSize + _topPadding + 20;

        final nodeCenters = [
          for (int i = 0; i < lessons.length; i++)
            Offset(
              _xOffsetFor(i, centerX),
              i * _verticalSpacing + _nodeSize / 2 + _topPadding,
            ),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 48),
          child: SizedBox(
            width: constraints.maxWidth,
            height: totalHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: DashedPathPainter(
                      points: nodeCenters,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
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
