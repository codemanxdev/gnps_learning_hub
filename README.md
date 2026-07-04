# GNPS Akhar

A gamified Flutter app for teaching kids Punjabi (Gurmukhi script), built
Android-first. No login/auth — progress lives entirely on-device via Hive
and is lost on uninstall by design.

## Getting started

```bash
flutter pub get
flutter run
```

The app runs immediately with **bundled mock lesson data** (see
`lib/repositories/mock_journey_data.dart`) — you don't need Firebase set up
to develop and test the UI/gameplay.

## Project structure

```
lib/
  models/          Lesson, Task, Journey, LocalProgress — plain Dart classes
                    with fromJson/toJson, shared between Firestore and Hive.
  repositories/
    content_repository.dart   Firestore + Hive cache for lesson content.
                               Falls back to mock data if Firebase isn't
                               configured or the device is offline.
    progress_repository.dart  Hive-only. User's points/streak/unlock state.
  services/
    progress_service.dart     Business logic: award points, unlock next
                               lesson, streak calculation (resets to 0 on
                               a missed day).
    audio_service.dart        flutter_tts wrapper. Android uses Google's
                               Punjabi (pa-IN) voice natively. iOS support
                               is a known gap — revisit when building iOS.
  providers.dart    Riverpod wiring for the above.
  screens/          SplashScreen -> JourneyScreen (+ ProfileScreen tab) ->
                    LessonScreen (dispatches to task widgets below).
  widgets/tasks/    One widget per task type:
                    trace, spelling, wordSelection, arrangeSentence, fillInBlank
```

## Connecting Firebase (when you're ready)

1. `dart pub global activate flutterfire_cli`
2. `flutterfire configure` — generates `lib/firebase_options.dart`
3. Uncomment the `options:` line in `main.dart`
4. In the Firebase Console, create this structure:
   ```
   journey (collection)
     meta (document)
       version: 1
       lessons (subcollection)
         lesson_001 { title, order, tasks: [...] }
         lesson_002 { ... }
   ```
   Match the exact field names used in `mock_journey_data.dart` — the app
   doesn't care whether content comes from Firestore or the bundled mock,
   as long as the JSON shape matches.
5. Set Firestore security rules so lessons are publicly readable but not
   writable from the app:
   ```
   match /journey/{document=**} {
     allow read: if true;
     allow write: if false;
   }
   ```
6. To push a content update: bump `version` in the `meta` doc and add/edit
   lesson documents. Kids get the update automatically next time they open
   the app (checked via `ContentRepository.checkForUpdatesAndSync()`,
   called from the splash screen).

## Adding real lesson images

Drop image files into `assets/images/` and reference them by path in your
lesson content (mock data or Firestore), e.g. `assets/images/dog.png`.
Missing images fail gracefully with a placeholder icon rather than crashing.

## Known gaps / next steps

- **iOS**: not yet supported — `flutter_tts` Punjabi pronunciation doesn't
  work reliably on iOS (AVSpeechSynthesizer has no Punjabi voice). Likely
  fix: bundle pre-recorded native-speaker audio for iOS instead of TTS.
- **Rewards/badges**: not yet implemented beyond points + streak.
- **Lesson images**: mock data references placeholder asset paths — add
  real images before shipping.
