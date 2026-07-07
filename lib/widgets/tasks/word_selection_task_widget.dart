import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../common/task_speaker_button.dart';
import '../common/task_header.dart';

class WordSelectionTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;

  const WordSelectionTaskWidget({super.key, required this.task, required this.onComplete});

  @override
  ConsumerState<WordSelectionTaskWidget> createState() => _WordSelectionTaskWidgetState();
}

class _WordSelectionTaskWidgetState extends ConsumerState<WordSelectionTaskWidget> {
  late final List<String> _options;
  String? _selected;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    final correct = widget.task.content['correctImageUrl'] as String;
    final distractors = List<String>.from(widget.task.content['distractorImageUrls'] as List);
    _options = [correct, ...distractors]..shuffle(Random());
  }

  void _select(String option) {
    final correct = widget.task.content['correctImageUrl'] as String;
    setState(() {
      _selected = option;
      _isCorrect = option == correct;
    });

    if (option == correct) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.task.content['word'] as String;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const TaskHeader(title: 'Select the correct image'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(word, style: Theme.of(context).textTheme.displaySmall),
              TaskSpeakerButton(textToSpeak: word),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: _options.map((imageUrl) {
                final isSelected = _selected == imageUrl;
                Color? borderColor;
                if (isSelected) {
                  borderColor = (_isCorrect ?? false) ? Colors.green : Colors.red;
                }
                return GestureDetector(
                  onTap: () => _select(imageUrl),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor ?? Colors.grey.shade300, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      // Assumes assets for mock data; swap to Image.network
                      // once images are served from Firestore/Storage URLs.
                      child: Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder:
                          (_, _, _) => const Icon(Icons.image_not_supported, size: 48)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
