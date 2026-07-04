import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/journey.dart';
import 'models/progress.dart';
import 'repositories/content_repository.dart';
import 'repositories/progress_repository.dart';
import 'services/audio_service.dart';
import 'services/progress_service.dart';

final contentRepositoryProvider = Provider((ref) => ContentRepository());
final progressRepositoryProvider = Provider((ref) => ProgressRepository());
final audioServiceProvider = Provider((ref) => AudioService());

final progressServiceProvider = Provider((ref) {
  return ProgressService(ref.read(progressRepositoryProvider));
});

/// Loaded once at splash time: checks Firestore for updates, falls back to
/// local/mock content on failure. See ContentRepository for details.
final journeyProvider = FutureProvider<Journey>((ref) async {
  final repo = ref.read(contentRepositoryProvider);
  return repo.checkForUpdatesAndSync();
});

/// Holds the user's local progress and exposes mutation methods used
/// throughout the app (completing lessons, registering app opens).
class ProgressNotifier extends StateNotifier<AsyncValue<LocalProgress>> {
  final ProgressRepository _repository;
  final ProgressService _service;

  ProgressNotifier(this._repository, this._service)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    final progress = await _repository.load();
    state = AsyncValue.data(progress);
  }

  Future<void> registerAppOpen() async {
    final current = state.value;
    if (current == null) return;
    final updated = await _service.registerAppOpen(current);
    state = AsyncValue.data(updated);
  }

  void ensureFirstLessonUnlocked(Journey journey) {
    final current = state.value;
    if (current == null) return;
    final updated = _service.ensureFirstLessonUnlocked(current, journey);
    state = AsyncValue.data(updated);
  }

  Future<void> completeLesson(Journey journey, String lessonId, int points) async {
    final current = state.value;
    if (current == null) return;
    final updated = await _service.completeLesson(
      progress: current,
      journey: journey,
      lessonId: lessonId,
      pointsEarned: points,
    );
    state = AsyncValue.data(LocalProgress.fromJson(updated.toJson()));
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<LocalProgress>>((ref) {
  return ProgressNotifier(
    ref.read(progressRepositoryProvider),
    ref.read(progressServiceProvider),
  );
});
