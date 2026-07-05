import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/journey.dart';
import '../models/lesson.dart';
import '../models/task.dart';
import '../providers.dart';
import '../widgets/journey/current_lesson_banner.dart';
import '../widgets/tasks/arrange_sentence_task_widget.dart';
import '../widgets/tasks/fill_in_blank_task_widget.dart';
import '../widgets/tasks/spelling_task_widget.dart';
import '../widgets/tasks/trace_task_widget.dart';
import '../widgets/tasks/word_selection_task_widget.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final Lesson lesson;
  final Journey journey;

  const LessonScreen({super.key, required this.lesson, required this.journey});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _taskIndex = 0;
  int _pointsEarned = 0;

  void _onTaskComplete(Task task) async {
    _pointsEarned += task.pointsAwarded;

    if (_taskIndex + 1 < widget.lesson.tasks.length) {
      setState(() => _taskIndex++);
    } else {
      await ref
          .read(progressProvider.notifier)
          .completeLesson(widget.journey, widget.lesson.id, _pointsEarned);
      if (mounted) _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Lesson complete! 🎉'),
        content: Text('You earned $_pointsEarned points.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // back to journey
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildTask(Task task) {
    switch (task.type) {
      case TaskType.trace:
        return TraceTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
        );
      case TaskType.spelling:
        return SpellingTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
        );
      case TaskType.wordSelection:
        return WordSelectionTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
        );
      case TaskType.arrangeSentence:
        return ArrangeSentenceTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
        );
      case TaskType.fillInBlank:
        return FillInBlankTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.lesson.tasks[_taskIndex];
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            progressAsync.when(
              data: (progress) => CurrentLessonBanner(
                lessonTitle: widget.lesson.title,
                taskIndex: _taskIndex,
                totalTasks: widget.lesson.tasks.length,
                streak: progress.currentStreak,
                points: progress.totalPoints,
                onBack: () => Navigator.of(context).pop(),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            Expanded(
              child: KeyedSubtree(
                key: ValueKey(task.id),
                child: _buildTask(task),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
