import '../models/journey.dart';
import '../models/progress.dart';
import '../repositories/progress_repository.dart';

class ProgressService {
  final ProgressRepository _repository;

  ProgressService(this._repository);

  /// Call once on app launch: bumps the streak if the user is active on
  /// a new calendar day, or resets it to 0 if a day was missed entirely.
  Future<LocalProgress> registerAppOpen(LocalProgress progress) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (progress.lastActiveDate == null) {
      progress.currentStreak = 1;
    } else {
      final last = progress.lastActiveDate!;
      final lastDay = DateTime(last.year, last.month, last.day);
      final dayDiff = today.difference(lastDay).inDays;

      if (dayDiff == 0) {
        // Same day, no change.
      } else if (dayDiff == 1) {
        progress.currentStreak += 1;
      } else {
        progress.currentStreak = 0;
        progress.currentStreak = 1; // today counts as a fresh start
      }
    }

    progress.lastActiveDate = today;
    await _repository.save(progress);
    return progress;
  }

  /// Ensures the first lesson is unlocked on a fresh install.
  Future<LocalProgress> ensureFirstLessonUnlocked(
    LocalProgress progress,
    Journey journey,
  ) async {
    final activeLessons = journey.activeLessons;
    if (progress.unlockedLessonIds.isEmpty && activeLessons.isNotEmpty) {
      progress.unlockedLessonIds.add(activeLessons.first.id);
      await _repository.save(progress);
    }
    return progress;
  }

  bool isLessonUnlocked(LocalProgress progress, String lessonId) =>
      progress.unlockedLessonIds.contains(lessonId);

  bool isLessonCompleted(LocalProgress progress, String lessonId) =>
      progress.completedLessonIds.contains(lessonId);

  /// Marks a lesson complete, awards points, and unlocks the next lesson
  /// in order (if there is one).
  Future<LocalProgress> completeLesson({
    required LocalProgress progress,
    required Journey journey,
    required String lessonId,
    required int pointsEarned,
  }) async {
    progress.completedLessonIds.add(lessonId);
    progress.totalPoints += pointsEarned;

    final activeLessons = journey.activeLessons;
    final index = activeLessons.indexWhere((l) => l.id == lessonId);
    if (index != -1 && index + 1 < activeLessons.length) {
      progress.unlockedLessonIds.add(activeLessons[index + 1].id);
    }

    await _repository.save(progress);
    return progress;
  }
}
