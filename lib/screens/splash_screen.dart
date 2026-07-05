import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'journey_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final minimumSplashTime = Future.delayed(const Duration(milliseconds: 1200));

    // Kick off content + progress loading in parallel.
    final journeyFuture = ref.read(journeyProvider.future);
    await ref.read(progressProvider.notifier).registerAppOpen();

    final journey = await journeyFuture;
    await ref.read(progressProvider.notifier).ensureFirstLessonUnlocked(journey);

    await minimumSplashTime;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const JourneyScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Swap for an Image.asset('assets/logo/logo.png') once you have one.
            Icon(
              Icons.school_rounded,
              size: 96,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 16),
            Text(
              'ਪੰਜਾਬੀ ਸਿੱਖੋ',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
