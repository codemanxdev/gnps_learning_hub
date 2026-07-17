import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/reward_config.dart';
import '../config/ui_strings.dart';
import '../models/journey.dart';
import '../models/lesson.dart';
import '../models/task.dart';
import '../providers/audio_providers.dart';
import '../providers/progress_providers.dart';
import '../widgets/confetti/confetti_overlay.dart';
import '../widgets/journey/current_lesson_banner.dart';
import '../widgets/journey/reward_burst_overlay.dart';
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
  bool _showingSuccess = false;

  final GlobalKey _starIconKey = GlobalKey();
  final GlobalKey<ConfettiOverlayState> _confettiKey = GlobalKey();

  List<Task> get _allTasks => widget.lesson.allTasks;

  @override
  void initState() {
    super.initState();
    _initializeTaskIndex();
  }

  void _initializeTaskIndex() {
    final progress = ref.read(progressProvider).value;
    if (progress == null) return;

    int accumulatedTasks = 0;
    for (final section in widget.lesson.sections) {
      if (progress.completedSectionIds.contains(section.id)) {
        accumulatedTasks += section.tasks.length;
      } else {
        break;
      }
    }
    // If the whole lesson was already completed, reset to 0 to allow replay,
    // otherwise start at the beginning of the first incomplete section.
    _taskIndex = accumulatedTasks < _allTasks.length ? accumulatedTasks : 0;
  }

  void _onTaskComplete(Task task) async {
    _pointsEarned += task.pointsAwarded;

    ref.read(audioServiceProvider).playSuccess();

    setState(() => _showingSuccess = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _showingSuccess = false);

    // Find which section this task belongs to
    LessonSection? currentSection;
    int accumulatedTasks = 0;
    for (final section in widget.lesson.sections) {
      accumulatedTasks += section.tasks.length;
      if (_taskIndex < accumulatedTasks) {
        currentSection = section;
        break;
      }
    }

    final isLastTaskInSection = _taskIndex + 1 == accumulatedTasks;
    final isLastTaskInLesson = _taskIndex + 1 == _allTasks.length;

    if (isLastTaskInSection) {
      await _handleSectionComplete(currentSection!, isLastTaskInLesson);
    } else {
      setState(() => _taskIndex++);
    }
  }

  Future<void> _handleSectionComplete(
    LessonSection section,
    bool isLastInLesson,
  ) async {
    ref.read(audioServiceProvider).playGemEarned();
    // Burst reward icons from the center of the screen
    final screenSize = MediaQuery.sizeOf(context);
    final origin = Offset(screenSize.width / 2, screenSize.height / 2);

    await showRewardBurst(
      context: context,
      origin: origin,
      targetKey: _starIconKey,
      icon: RewardConfig.icon,
      color: RewardConfig.color,
      count: 8,
    );

    if (!mounted) return;

    // Persist progress for this section
    await ref
        .read(progressProvider.notifier)
        .completeSection(
          journey: widget.journey,
          lessonId: widget.lesson.id,
          sectionId: section.id,
          points: _pointsEarned,
        );

    // Capture this section's points before resetting for the next one,
    // so the dialogs below always show the right number.
    final sectionPoints = _pointsEarned;
    _pointsEarned = 0;

    if (isLastInLesson) {
      ref.read(audioServiceProvider).playLessonCompleted();
      _confettiKey.currentState?.play();
      if (mounted) _showCompletionDialog(sectionPoints);
    } else {
      if (mounted) _showSectionCompletionDialog(section, sectionPoints);
    }
  }

  void _onTaskIncorrect() {
    final progress = ref.read(progressProvider).value;
    if (progress?.hapticsEnabled ?? true) {
      HapticFeedback.heavyImpact();
    }
    ref.read(audioServiceProvider).playFailure();
  }

  void _showSectionCompletionDialog(LessonSection section, int pointsEarned) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('${section.title} Complete! 🏆'),
        content: Text(
          'Great job! You earned $pointsEarned ${RewardConfig.labelPlural}. '
          'Ready for the next chapter?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // back to journey
            },
            child: const Text(UIStrings.backToJourney),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              setState(
                () => _taskIndex++,
              ); // move to next task (start of next section)
            },
            child: const Text(UIStrings.continueLabel),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(int pointsEarned) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Lesson complete! 🎉'),
        content: Text('You earned $pointsEarned ${RewardConfig.labelPlural}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(UIStrings.continueLabel),
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
          onIncorrect: _onTaskIncorrect,
        );
      case TaskType.spelling:
        return SpellingTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
          onIncorrect: _onTaskIncorrect,
        );
      case TaskType.wordSelection:
        return WordSelectionTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
          onIncorrect: _onTaskIncorrect,
        );
      case TaskType.arrangeSentence:
        return ArrangeSentenceTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
          onIncorrect: _onTaskIncorrect,
        );
      case TaskType.fillInBlank:
        return FillInBlankTaskWidget(
          task: task,
          onComplete: () => _onTaskComplete(task),
          onIncorrect: _onTaskIncorrect,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = _allTasks;
    if (allTasks.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No tasks in this lesson')),
      );
    }

    final task = allTasks[_taskIndex];
    final progressAsync = ref.watch(progressProvider);

    String? currentSectionTitle;
    int accumulatedTasks = 0;
    for (final section in widget.lesson.sections) {
      if (_taskIndex < accumulatedTasks + section.tasks.length) {
        currentSectionTitle = section.title;
        break;
      }
      accumulatedTasks += section.tasks.length;
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            progressAsync.when(
              data: (progress) => CurrentLessonBanner(
                lessonTitle: widget.lesson.title,
                sectionTitle: currentSectionTitle,
                taskIndex: _taskIndex,
                totalTasks: allTasks.length,
                streak: progress.currentStreak,
                points: progress.totalPoints,
                onBack: () => Navigator.of(context).pop(),
                iconKey: _starIconKey,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: KeyedSubtree(
                      key: ValueKey(task.id),
                      child: _buildTask(task),
                    ),
                  ),
                  if (_showingSuccess)
                    Container(
                      color: Colors.white.withValues(alpha: 0.8),
                      child: Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(scale: value, child: child);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 120,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Correct!',
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(child: ConfettiOverlay(key: _confettiKey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
