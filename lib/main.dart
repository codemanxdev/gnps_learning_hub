import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/splash_screen.dart';

// Uncomment once you've run `flutterfire configure` — it generates this file.
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Firebase is optional for local development: if it isn't configured yet,
  // ContentRepository quietly falls back to bundled mock lesson data.
  try {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Not configured yet — app continues to run on mock/local data.
  }

  runApp(const ProviderScope(child: PunjabiJourneyApp()));
}

class PunjabiJourneyApp extends StatelessWidget {
  const PunjabiJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punjabi Journey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
