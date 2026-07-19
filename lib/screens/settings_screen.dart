import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:package_info_plus/package_info_plus.dart';

import '../providers/content_providers.dart';
import '../providers/progress_providers.dart';
import '../tools/tracing_checkpoint_recorder_screen.dart';
import 'intro_screen.dart';

const List<Color> _themeColorOptions = [
  Colors.blue,
  Colors.purple,
  Colors.pink,
  Colors.red,
  Colors.orange,
  Colors.amber,
  Colors.green,
  Colors.teal,
  Colors.indigo,
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmAndReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Factory Reset?'),
        content: const Text(
          'This clears all points, streaks, and lesson progress, and reloads '
          'lesson content fresh. This can\'t be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(progressProvider.notifier).reset();
    await ref.read(contentRepositoryProvider).clearCache();

    // Fetch fresh content directly from the repository (bypassing the
    // journeySyncProvider state machine, which is meant for the one-time
    // splash-screen sync, not for ad-hoc reloads like this).
    final journey = await ref
        .read(contentRepositoryProvider)
        .checkForUpdatesAndSync();

    // Keep journeyProvider/journeySyncProvider in sync with the new content
    // in case any still-mounted screen watches them.
    ref.invalidate(journeySyncProvider);

    await ref
        .read(progressProvider.notifier)
        .ensureFirstLessonUnlocked(journey);

    // reset() leaves hasCompletedOnboarding = false, so send the user back
    // through onboarding and clear the stack so back-navigation can't
    // return them to a screen built against the now-wiped state.
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const IntroScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _debugCompleteAllLessons(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // journeyProvider should already hold data by the time settings is
    // reachable; fall back to a direct repository read just in case.
    final journey =
        ref.read(journeyProvider).value ??
        await ref.read(contentRepositoryProvider).getLocalJourney();

    await ref.read(progressProvider.notifier).debugCompleteAllLessons(journey);

    if (context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text('All lessons marked complete (debug).')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: progressAsync.when(
        data: (progress) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.volume_up_outlined),
              title: const Text('Sound'),
              value: progress.soundEnabled,
              onChanged: (value) {
                ref.read(progressProvider.notifier).updateSoundEnabled(value);
                if (value) SystemSound.play(SystemSoundType.click);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: const Text('Haptic feedback'),
              value: progress.hapticsEnabled,
              onChanged: (value) {
                ref.read(progressProvider.notifier).updateHapticsEnabled(value);
                if (value) HapticFeedback.heavyImpact();
              },
            ),
            const Divider(height: 32),
            const _SectionHeader('Theme color'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _themeColorOptions.map((color) {
                  final isSelected =
                      progress.themeSeedColor == color.toARGB32();
                  return GestureDetector(
                    onTap: () => ref
                        .read(progressProvider.notifier)
                        .updateThemeSeedColor(color.toARGB32()),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 32),
            const _SectionHeader('About'),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final appVersion = snapshot.hasData
                    ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                    : '—';
                final journeyVersion = ref
                    .watch(journeyProvider)
                    .maybeWhen(data: (j) => '${j.version}', orElse: () => '—');

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: const Icon(Icons.info_outline),
                      title: const Text('App version'),
                      trailing: Text(appVersion),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: const Icon(Icons.menu_book_outlined),
                      title: const Text('Lesson content version'),
                      trailing: Text(journeyVersion),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 32),
            _SettingsActionButton(
              onPressed: () => _confirmAndReset(context, ref),
              icon: Icons.restart_alt,
              label: 'Factory Reset',
              isDestructive: true,
            ),
            if (kDebugMode) ...[
              const Divider(height: 32),
              const _SectionHeader('Debug Tools'),
              _SettingsActionButton(
                onPressed: () => _debugCompleteAllLessons(context, ref),
                icon: Icons.done_all,
                label: 'Mark All Lessons Complete',
              ),
              const SizedBox(height: 12),
              _SettingsActionButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CheckpointRecorderScreen(),
                  ),
                ),
                icon: Icons.edit_road,
                label: 'Tracing Checkpoint Recorder',
              ),
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading settings: $e')),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _SettingsActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _SettingsActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: color != null ? BorderSide(color: color) : null,
          minimumSize: const Size(double.infinity, 52),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
