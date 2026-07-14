import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/journey.dart';
import 'models/progress.dart';
import 'models/shop_item.dart';
import 'repositories/content_repository.dart';
import 'repositories/progress_repository.dart';
import 'services/audio_service.dart';
import 'services/progress_service.dart';
import 'repositories/shop_repository.dart';

final contentRepositoryProvider = Provider((ref) => ContentRepository());
final progressRepositoryProvider = Provider((ref) => ProgressRepository());
final audioServiceProvider = Provider((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

final progressServiceProvider = Provider((ref) {
  return ProgressService(ref.read(progressRepositoryProvider));
});

final journeyProvider = FutureProvider<Journey>((ref) async {
  final repo = ref.read(contentRepositoryProvider);
  return repo.checkForUpdatesAndSync();
});

final shopRepositoryProvider = Provider((ref) => ShopRepository());

final shopCatalogProvider = Provider<List<ShopItem>>((ref) {
  return ref.read(shopRepositoryProvider).getCatalog();
});

class ProgressNotifier extends StateNotifier<AsyncValue<LocalProgress>> {
  final ProgressRepository _repository;
  final ProgressService _service;
  final AudioService _audioService;
  late final Future<void> _initialLoad;

  ProgressNotifier(this._repository, this._service, this._audioService)
    : super(const AsyncValue.loading()) {
    _initialLoad = _load();
  }

  Future<void> _load() async {
    final progress = await _repository.load();
    _audioService.soundEnabled = progress.soundEnabled;
    _audioService.hapticsEnabled = progress.hapticsEnabled;
    state = AsyncValue.data(progress);
  }

  Future<void> registerAppOpen() async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.registerAppOpen(current);
    state = AsyncValue.data(updated);
  }

  Future<void> ensureFirstLessonUnlocked(Journey journey) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.ensureFirstLessonUnlocked(current, journey);
    state = AsyncValue.data(updated);
  }

  Future<void> completeSection({
    required Journey journey,
    required String lessonId,
    required String sectionId,
    required int points,
  }) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.completeSection(
      progress: current,
      journey: journey,
      lessonId: lessonId,
      sectionId: sectionId,
      pointsEarned: points,
    );
    state = AsyncValue.data(LocalProgress.fromJson(updated.toJson()));
  }

  /// DEBUG ONLY. See ProgressService.debugCompleteAllLessons.
  Future<void> debugCompleteAllLessons(Journey journey) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.debugCompleteAllLessons(
      progress: current,
      journey: journey,
    );
    state = AsyncValue.data(LocalProgress.fromJson(updated.toJson()));
  }

  Future<PurchaseResult> purchaseItem(ShopItem item) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return PurchaseResult.insufficientGems;
    final (updated, result) = await _service.purchaseItem(
      progress: current,
      item: item,
    );
    state = AsyncValue.data(LocalProgress.fromJson(updated.toJson()));
    return result;
  }

  /// Equips [item] into its avatar slot. [item] must already be owned
  /// (or free/default) — callers should only offer owned items in the
  /// customization UI. No-ops if the item has no avatarSlot.
  Future<void> equipItem(ShopItem item) async {
    await _initialLoad;
    final current = state.value;
    if (current == null || item.avatarSlot == null) return;

    final owned =
        item.price == 0 || (current.ownedItemQuantities[item.id] ?? 0) > 0;
    if (!owned) return;

    final updatedEquipped = Map<String, String>.from(current.equippedItemIds)
      ..[item.avatarSlot!.name] = item.id;

    final updated = LocalProgress.fromJson(current.toJson())
      ..equippedItemIds = updatedEquipped;

    await _repository.save(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> reset() async {
    await _initialLoad;
    await _repository.clear();
    final fresh = LocalProgress();
    await _repository.save(fresh);
    state = AsyncValue.data(fresh);
  }

  Future<void> updateUserName(String name) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateUserName(current, name);
    state = AsyncValue.data(updated);
  }

  Future<void> updateSoundEnabled(bool enabled) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateSoundEnabled(current, enabled);
    _audioService.soundEnabled = enabled;
    state = AsyncValue.data(updated);
  }

  Future<void> updateHapticsEnabled(bool enabled) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateHapticsEnabled(current, enabled);
    _audioService.hapticsEnabled = enabled;
    state = AsyncValue.data(updated);
  }

  Future<void> updateThemeSeedColor(int colorValue) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = await _service.updateThemeSeedColor(current, colorValue);
    state = AsyncValue.data(updated);
  }

  Future<void> updateDailyGoal(int minutes) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = LocalProgress.fromJson(current.toJson())
      ..dailyGoalMinutes = minutes;
    await _repository.save(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> addPoints(int points) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = LocalProgress.fromJson(current.toJson())
      ..totalPoints += points;
    await _repository.save(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> consumeItem(String itemId) async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;

    final count = current.ownedItemQuantities[itemId] ?? 0;
    if (count <= 0) return;

    final updated = LocalProgress.fromJson(current.toJson());
    updated.ownedItemQuantities[itemId] = count - 1;

    await _repository.save(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> completeOnboarding() async {
    await _initialLoad;
    final current = state.value;
    if (current == null) return;
    final updated = LocalProgress.fromJson(current.toJson())
      ..hasCompletedOnboarding = true;
    await _repository.save(updated);
    state = AsyncValue.data(updated);
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<LocalProgress>>((ref) {
      return ProgressNotifier(
        ref.read(progressRepositoryProvider),
        ref.read(progressServiceProvider),
        ref.read(audioServiceProvider),
      );
    });
