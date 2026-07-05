import 'package:flutter/material.dart';

class CurrentLessonBanner extends StatelessWidget {
  final String lessonTitle;
  final int taskIndex; // 0-based
  final int totalTasks;
  final int streak;
  final int points;
  final VoidCallback onBack;

  const CurrentLessonBanner({
    super.key,
    required this.lessonTitle,
    required this.taskIndex,
    required this.totalTasks,
    required this.streak,
    required this.points,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progressFraction = totalTasks == 0 ? 0.0 : (taskIndex) / totalTasks;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: scheme.onPrimary),
                onPressed: onBack,
              ),
              const Spacer(),
              _StatChip(
                icon: Icons.local_fire_department,
                color: Colors.orangeAccent,
                value: '$streak',
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.star_rounded,
                color: Colors.amberAccent,
                value: '$points',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              lessonTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: scheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    minHeight: 8,
                    backgroundColor: scheme.onPrimary.withValues(alpha: 0.25),
                    valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Task ${taskIndex + 1} of $totalTasks',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
