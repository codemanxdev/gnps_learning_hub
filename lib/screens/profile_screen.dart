import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/reward_config.dart';
import '../models/shop_item.dart';
import '../providers.dart';
import 'avatar_customization_screen.dart';
import 'streak_screen.dart';
import 'shop_screen.dart';
import '../widgets/avatar/avatar_preview.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmAndReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset progress?'),
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
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(progressProvider.notifier).reset();
    await ref.read(contentRepositoryProvider).clearCache();
    ref.invalidate(journeyProvider);

    final journey = await ref.read(journeyProvider.future);
    await ref
        .read(progressProvider.notifier)
        .ensureFirstLessonUnlocked(journey);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Progress reset.')));
    }
  }

  void _openStreakScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const StreakScreen()));
  }

  void _openShopScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ShopScreen()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);
    final catalog = ref.watch(shopCatalogProvider); // List<ShopItem>, sync

    return progressAsync.when(
      data: (progress) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Center(
                child: _AvatarWithEditBadge(
                  equippedItemIds: progress.equippedItemIds,
                  catalog: catalog,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AvatarCustomizationScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openStreakScreen(context),
                      child: _StatCard(
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                        label: 'Streak',
                        value:
                            '${progress.currentStreak} day${progress.currentStreak == 1 ? '' : 's'}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openShopScreen(context),
                      child: _StatCard(
                        icon: RewardConfig.icon,
                        color: RewardConfig.color,
                        label:
                            RewardConfig.labelPlural[0].toUpperCase() +
                            RewardConfig.labelPlural.substring(1),
                        value: '${progress.totalPoints}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Lessons completed: ${progress.completedLessonIds.length}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _confirmAndReset(context, ref),
                icon: const Icon(Icons.restart_alt, color: Colors.red),
                label: const Text(
                  'Reset Progress',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading profile: $e')),
    );
  }
}

class _AvatarWithEditBadge extends StatelessWidget {
  final Map<String, String> equippedItemIds;
  final List<ShopItem> catalog;
  final VoidCallback onTap;

  const _AvatarWithEditBadge({
    required this.equippedItemIds,
    required this.catalog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: SizedBox(
                width: 96,
                height: 96,
                child: AvatarPreview(
                  equippedItemIds: equippedItemIds,
                  catalog: catalog,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
