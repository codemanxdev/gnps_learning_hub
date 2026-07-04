import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/journey.dart';
import 'mock_journey_data.dart';

/// The single source of truth for lesson content.
///
/// - Reads/writes a local Hive cache so the app works fully offline.
/// - Talks to Firestore only to check a lightweight version number and,
///   if newer, pull the full lesson set.
/// - Falls back to bundled mock data if Firestore isn't configured yet
///   or the device has no network — this lets the app run standalone
///   before Firebase is set up.
class ContentRepository {
  static const _boxName = 'content_cache';
  static const _journeyKey = 'journey';

  Box? _box;

  Future<void> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
  }

  /// Returns whatever journey is available locally right now, without
  /// making a network call. Falls back to mock data on first-ever launch.
  Future<Journey> getLocalJourney() async {
    await _ensureBox();
    final cached = _box!.get(_journeyKey) as String?;
    if (cached != null) {
      return Journey.fromJson(jsonDecode(cached) as Map<String, dynamic>);
    }
    await _cacheJourney(mockJourney);
    return mockJourney;
  }

  Future<void> _cacheJourney(Journey journey) async {
    await _ensureBox();
    await _box!.put(_journeyKey, jsonEncode(journey.toJson()));
  }

  /// Checks Firestore for a newer content version and updates the local
  /// cache if one is found. Call this on app launch (from splash screen).
  /// Safe to call even if Firebase hasn't been configured yet — errors
  /// are swallowed and the app continues with whatever is cached locally.
  Future<Journey> checkForUpdatesAndSync() async {
    final local = await getLocalJourney();
    try {
      final firestore = FirebaseFirestore.instance;

      final metaDoc = await firestore.collection('journey').doc('meta').get();
      final remoteVersion = (metaDoc.data()?['version'] as num?)?.toInt();

      if (remoteVersion == null || remoteVersion <= local.version) {
        return local; // already up to date, or meta doc not set up yet
      }

      final lessonsSnapshot = await firestore
          .collection('journey')
          .doc('meta')
          .collection('lessons')
          .orderBy('order')
          .get();

      final remoteJourney = Journey.fromJson({
        'version': remoteVersion,
        'lessons': lessonsSnapshot.docs.map((d) => d.data()).toList(),
      });

      await _cacheJourney(remoteJourney);
      return remoteJourney;
    } catch (_) {
      // No Firebase configured yet, or offline — just use local cache.
      return local;
    }
  }
}
