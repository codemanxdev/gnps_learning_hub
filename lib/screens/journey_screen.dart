import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lesson.dart';
import '../providers.dart';
import 'lesson_screen.dart';
import 'profile_screen.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final journeyAsync = ref.watch(journeyProvider);
    final progressAsync = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Journey')),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          journeyAsync.when(
            data: (journey) => progressAsync.when(
              data: (progress) => _LessonPath(
                lessons: journey.lessons,
                unlockedIds: progress.unlockedLessonIds,
                completedIds: progress.completedLessonIds,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading progress: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading lessons: $e')),
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Journey'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _LessonPath extends ConsumerWidget {
  final List<Lesson> lessons;
  final Set<String> unlockedIds;
  final Set<String> completedIds;

  const _LessonPath({
    required this.lessons,
    required this.unlockedIds,
    required this.completedIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isUnlocked = unlockedIds.contains(lesson.id);
        final isCompleted = completedIds.contains(lesson.id);

        return Card(
          elevation: isUnlocked ? 2 : 0,
          color: isUnlocked ? null : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCompleted
                  ? Colors.green
                  : (isUnlocked ? Theme.of(context).colorScheme.primary : Colors.grey),
              child: Icon(
                isCompleted
                    ? Icons.check
                    : (isUnlocked ? Icons.play_arrow : Icons.lock_outline),
                color: Colors.white,
              ),
            ),
            title: Text(lesson.title),
            subtitle: Text('${lesson.tasks.length} activities'),
            enabled: isUnlocked,
            onTap: isUnlocked
                ? () async {
                    final journey = await ref.read(journeyProvider.future);
                    if (!context.mounted) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(lesson: lesson, journey: journey),
                      ),
                    );
                  }
                : null,
          ),
        );
      },
    );
  }
}
