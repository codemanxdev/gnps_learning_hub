import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/journey_data.dart';
import '../models/journey.dart';

class ContentRepository {
  static const _boxName = 'content_cache';
  static const _journeyKey = 'journey';

  Box? _box;

  Future<void> _ensureBox() async {
    _box ??= await Hive.openBox(_boxName);
  }

  Future<Journey> getLocalJourney() async {
    await _ensureBox();
    final cached = _box!.get(_journeyKey) as String?;

    if (cached == null) {
      await _cacheJourney(journeyData);
      return journeyData;
    }

    try {
      final cachedJourney = Journey.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );

      if (journeyData.version > cachedJourney.version) {
        await _cacheJourney(journeyData);
        return journeyData;
      }

      return cachedJourney;
    } catch (e) {
      // If cached data is corrupted or incompatible with new models,
      // overwrite it with the fresh mock data.
      await _cacheJourney(journeyData);
      return journeyData;
    }
  }

  Future<void> _cacheJourney(Journey journey) async {
    await _ensureBox();
    await _box!.put(_journeyKey, jsonEncode(journey.toJson()));
  }

  Future<Journey> checkForUpdatesAndSync() async {
    final local = await getLocalJourney();
    try {
      final firestore = FirebaseFirestore.instance;

      final metaDoc = await firestore.collection('journey').doc('meta').get();
      final remoteVersion = (metaDoc.data()?['version'] as num?)?.toInt();

      if (remoteVersion == null || remoteVersion <= local.version) {
        return local;
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
      return local;
    }
  }

  /// Wipes the cached content, forcing the next load to fall back to
  /// bundled mock data (or re-fetch from Firestore). Used by the
  /// "Reset Progress" button so testers don't have to clear app storage.
  Future<void> clearCache() async {
    await _ensureBox();
    await _box!.delete(_journeyKey);
  }
}
