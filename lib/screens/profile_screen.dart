import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider);

    return progressAsync.when(
      data: (progress) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                    label: 'Streak',
                    value: '${progress.currentStreak} day${progress.currentStreak == 1 ? '' : 's'}',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    icon: Icons.star,
                    color: Colors.amber,
                    label: 'Points',
                    value: '${progress.totalPoints}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Lessons completed: ${progress.completedLessonIds.length}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading profile: $e')),
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
