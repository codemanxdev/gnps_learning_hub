import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class TaskSpeakerButton extends ConsumerWidget {
  final String textToSpeak;
  final double iconSize;

  const TaskSpeakerButton({
    super.key,
    required this.textToSpeak,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.volume_up, size: iconSize),
      onPressed: () => ref.read(audioServiceProvider).speak(textToSpeak),
      tooltip: 'Hear pronunciation',
    );
  }
}
