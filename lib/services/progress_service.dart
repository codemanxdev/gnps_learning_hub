import '../models/journey.dart';
import '../models/progress.dart';
import '../models/shop_item.dart';
import '../repositories/progress_repository.dart';

enum PurchaseResult { success, insufficientGems, alreadyOwned }

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

  /// Ensures the first lesson is unlocked.
  Future<LocalProgress> ensureFirstLessonUnlocked(
    LocalProgress progress,
    Journey journey,
  ) async {
    final activeLessons = journey.activeLessons;
    if (activeLessons.isNotEmpty) {
      final firstLessonId = activeLessons.first.id;
      // Unlock the first lesson if nothing is unlocked yet,
      // or if the current journey's first lesson is missing from progress.
      if (!progress.unlockedLessonIds.contains(firstLessonId)) {
        progress.unlockedLessonIds.add(firstLessonId);
        await _repository.save(progress);
      }
    }
    return progress;
  }

  bool isLessonUnlocked(LocalProgress progress, String lessonId) =>
      progress.unlockedLessonIds.contains(lessonId);

  bool isLessonCompleted(LocalProgress progress, String lessonId) =>
      progress.completedLessonIds.contains(lessonId);

  bool isSectionCompleted(LocalProgress progress, String sectionId) =>
      progress.completedSectionIds.contains(sectionId);

  /// Marks a section (chapter) complete, awards points, and if all sections
  /// in the lesson are done, unlocks the next lesson.
  Future<LocalProgress> completeSection({
    required LocalProgress progress,
    required Journey journey,
    required String lessonId,
    required String sectionId,
    required int pointsEarned,
  }) async {
    progress.completedSectionIds.add(sectionId);
    progress.totalPoints += pointsEarned;

    // Check if the whole lesson is now complete
    final lesson = journey.lessons.firstWhere((l) => l.id == lessonId);
    final allSectionsCompleted =
        lesson.sections.every((s) => progress.completedSectionIds.contains(s.id));

    if (allSectionsCompleted) {
      progress.completedLessonIds.add(lessonId);

      final activeLessons = journey.activeLessons;
      final index = activeLessons.indexWhere((l) => l.id == lessonId);
      if (index != -1 && index + 1 < activeLessons.length) {
        progress.unlockedLessonIds.add(activeLessons[index + 1].id);
      }
    }

    await _repository.save(progress);
    return progress;
  }

  /// How many of [itemId] the user currently owns (0 if none).
  int itemQuantity(LocalProgress progress, String itemId) =>
      progress.ownedItemQuantities[itemId] ?? 0;

  /// Whether the user owns at least one of [itemId].
  bool isItemOwned(LocalProgress progress, String itemId) =>
      itemQuantity(progress, itemId) > 0;

  /// Attempts to buy [item] with gems from [progress.totalPoints].
  ///
  /// Non-stackable items (e.g. cosmetic avatars) can only be bought once;
  /// stackable items (e.g. streak freezes) can be bought repeatedly to
  /// build up a quantity. Does not mutate [progress] on failure.
  ///
  /// NOTE: this only records ownership/quantity — it doesn't yet wire the
  /// streak freeze into registerAppOpen's streak-reset logic, so owning
  /// one doesn't actually protect a missed day yet. That's a separate
  /// change to registerAppOpen if/when you want it to consume one.
  Future<(LocalProgress, PurchaseResult)> purchaseItem({
    required LocalProgress progress,
    required ShopItem item,
  }) async {
    if (!item.stackable && isItemOwned(progress, item.id)) {
      return (progress, PurchaseResult.alreadyOwned);
    }
    if (progress.totalPoints < item.price) {
      return (progress, PurchaseResult.insufficientGems);
    }

    progress.totalPoints -= item.price;
    progress.ownedItemQuantities[item.id] = itemQuantity(progress, item.id) + 1;

    await _repository.save(progress);
    return (progress, PurchaseResult.success);
  }
}
