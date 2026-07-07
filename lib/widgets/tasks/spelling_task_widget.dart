import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../common/task_speaker_button.dart';
import '../common/task_check_button.dart';
import '../common/task_header.dart';

/// Presents an image + word bank; the child drags letter/syllable tiles
/// from the bank into a build area to spell the target word. The bank
/// includes distractor tiles that don't belong in the answer.
class SpellingTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;

  const SpellingTaskWidget({super.key, required this.task, required this.onComplete});

  @override
  ConsumerState<SpellingTaskWidget> createState() => _SpellingTaskWidgetState();
}

class _SpellingTaskWidgetState extends ConsumerState<SpellingTaskWidget> {
  late List<_Tile> _bankTiles;
  final List<_Tile> _builtTiles = [];
  bool? _lastCheckCorrect;

  @override
  void initState() {
    super.initState();
    final letterBank = List<String>.from(widget.task.content['letterBank'] as List);
    _bankTiles = [
      for (int i = 0; i < letterBank.length; i++) _Tile(id: i, text: letterBank[i]),
    ]..shuffle(Random());
  }

  void _moveToBuilt(_Tile tile) {
    setState(() {
      _bankTiles.remove(tile);
      _builtTiles.add(tile);
      _lastCheckCorrect = null;
    });
  }

  void _moveToBank(_Tile tile) {
    setState(() {
      _builtTiles.remove(tile);
      _bankTiles.add(tile);
      _lastCheckCorrect = null;
    });
  }

  void _check() {
    final targetWord = widget.task.content['targetWord'] as String;
    final built = _builtTiles.map((t) => t.text).join();
    final isCorrect = built == targetWord;
    setState(() => _lastCheckCorrect = isCorrect);

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    }
  }

  Widget _buildDraggableTile(_Tile tile, {required bool inBank}) {
    final chip = Card(
      color: inBank ? null : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(tile.text, style: const TextStyle(fontSize: 22)),
      ),
    );

    return Draggable<_Tile>(
      data: tile,
      feedback: Material(color: Colors.transparent, child: chip),
      childWhenDragging: Opacity(opacity: 0.3, child: chip),
      child: GestureDetector(
        onTap: () => inBank ? _moveToBuilt(tile) : _moveToBank(tile),
        child: chip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.task.content['imageUrl'] as String;
    final targetWord = widget.task.content['targetWord'] as String;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const TaskHeader(title: 'Spell the word'),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder:
                  (_, _, _) => const Icon(Icons.image_not_supported, size: 64)),
            ),
          ),
          const SizedBox(height: 8),
          TaskSpeakerButton(textToSpeak: targetWord),
          const SizedBox(height: 16),
          // Build area
          DragTarget<_Tile>(
            onAcceptWithDetails: (details) => _moveToBuilt(details.data),
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 72),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _lastCheckCorrect == null
                        ? Colors.grey.shade400
                        : (_lastCheckCorrect! ? Colors.green : Colors.red),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _builtTiles.map((t) => _buildDraggableTile(t, inBank: false)).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Drag letters here', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          // Letter bank
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bankTiles.map((t) => _buildDraggableTile(t, inBank: true)).toList(),
          ),
          const Spacer(),
          TaskCheckButton(
            onPressed: _builtTiles.isEmpty ? null : _check,
          ),
        ],
      ),
    );
  }
}

class _Tile {
  final int id;
  final String text;
  _Tile({required this.id, required this.text});
}
