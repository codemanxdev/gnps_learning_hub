import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/journey.dart';
import '../repositories/content_repository.dart';

final contentRepositoryProvider = Provider((ref) => ContentRepository());

sealed class JourneySyncState {
  const JourneySyncState();
}

class JourneyChecking extends JourneySyncState {
  const JourneyChecking();
}

class JourneyInstallingUpdate extends JourneySyncState {
  final int fromVersion;
  final int toVersion;

  const JourneyInstallingUpdate({
    required this.fromVersion,
    required this.toVersion,
  });
}

class JourneyReady extends JourneySyncState {
  final Journey journey;
  final bool wasUpdated;

  const JourneyReady({required this.journey, required this.wasUpdated});
}

class JourneySyncNotifier extends StateNotifier<JourneySyncState> {
  final ContentRepository _repository;
  final _readyCompleter = Completer<Journey>();

  /// Completes once a usable journey is ready (whether served from cache
  /// or freshly installed). Screens that need to imperatively await sync
  /// completion (e.g. the splash screen) can use this instead of watching
  /// `state` directly.
  Future<Journey> get ready => _readyCompleter.future;

  JourneySyncNotifier(this._repository) : super(const JourneyChecking()) {
    _sync();
  }

  Future<void> _sync() async {
    // Add a small artificial delay so the "Checking for updates" status is actually visible.
    final minimumCheckingTime = Future.delayed(const Duration(milliseconds: 2400));

    final local = await _repository.getLocalJourney();
    final remoteVersion = await _repository.fetchRemoteVersion();

    if (remoteVersion == null || remoteVersion <= local.version) {
      await minimumCheckingTime;
      state = JourneyReady(journey: local, wasUpdated: false);
      _readyCompleter.complete(local);
      return;
    }

    await minimumCheckingTime;
    state = JourneyInstallingUpdate(
      fromVersion: local.version,
      toVersion: remoteVersion,
    );

    final minimumInstallingTime = Future.delayed(
      const Duration(milliseconds: 400),
    );

    try {
      final installed = await _repository.fetchAndCacheRemoteJourney(
        remoteVersion,
      );
      await minimumInstallingTime;
      state = JourneyReady(journey: installed, wasUpdated: true);
      _readyCompleter.complete(installed);
    } catch (_) {
      await minimumInstallingTime;
      state = JourneyReady(journey: local, wasUpdated: false);
      _readyCompleter.complete(local);
    }
  }
}

final journeySyncProvider =
    StateNotifierProvider<JourneySyncNotifier, JourneySyncState>((ref) {
      return JourneySyncNotifier(ref.read(contentRepositoryProvider));
    });

final journeyProvider = Provider<AsyncValue<Journey>>((ref) {
  final syncState = ref.watch(journeySyncProvider);
  return switch (syncState) {
    JourneyChecking() => const AsyncValue.loading(),
    JourneyInstallingUpdate() => const AsyncValue.loading(),
    JourneyReady(:final journey) => AsyncValue.data(journey),
  };
});
