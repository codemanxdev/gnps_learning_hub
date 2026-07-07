import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../common/task_speaker_button.dart';
import '../common/task_header.dart';

class FillInBlankTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;

  const FillInBlankTaskWidget({super.key, required this.task, required this.onComplete});

  @override
  ConsumerState<FillInBlankTaskWidget> createState() => _FillInBlankTaskWidgetState();
}

class _FillInBlankTaskWidgetState extends ConsumerState<FillInBlankTaskWidget> {
  String? _selected;
  bool? _isCorrect;

  void _select(String option) {
    final correctWord = widget.task.content['correctWord'] as String;
    setState(() {
      _selected = option;
      _isCorrect = option == correctWord;
    });
    if (option == correctWord) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts = List<String>.from(widget.task.content['sentenceParts'] as List);
    final options = List<String>.from(widget.task.content['options'] as List);
    final correctWord = widget.task.content['correctWord'] as String;

    final displaySentence = parts.map((p) => p == '___' ? (_selected ?? '___') : p).join(' ');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const TaskHeader(title: 'Fill in the blank'),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  displaySentence,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              TaskSpeakerButton(
                textToSpeak: parts.map((p) => p == '___' ? correctWord : p).join(' '),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: options.map((option) {
              final isSelected = _selected == option;
              Color? color;
              if (isSelected) {
                color = (_isCorrect ?? false) ? Colors.green : Colors.red;
              }
              return OutlinedButton(
                onPressed: () => _select(option),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color ?? Colors.grey.shade400, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
