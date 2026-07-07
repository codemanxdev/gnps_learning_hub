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

  Widget _buildBuiltTile(_Tile tile) {
    return GestureDetector(
      onTap: () => _moveToBank(tile),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tile.text,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          Container(
            width: 30,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankTile(_Tile tile) {
    final chip = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          tile.text,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Draggable<_Tile>(
      data: tile,
      feedback: Material(color: Colors.transparent, child: chip),
      childWhenDragging: Opacity(opacity: 0.2, child: chip),
      child: GestureDetector(
        onTap: () => _moveToBuilt(tile),
        child: chip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.task.content['imageUrl'] as String;
    final targetWord = widget.task.content['targetWord'] as String;
    final builtWord = _builtTiles.map((t) => t.text).join();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const TaskHeader(title: 'Spell the word'),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder:
                  (_, _, _) => const Icon(Icons.image_not_supported, size: 64)),
            ),
          ),
          const SizedBox(height: 12),
          TaskSpeakerButton(textToSpeak: targetWord),
          const SizedBox(height: 20),
          
          // Resulting Word Preview (This makes matras look correct)
          if (_builtTiles.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                builtWord,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: _lastCheckCorrect == null
                      ? Colors.black
                      : (_lastCheckCorrect! ? Colors.green : Colors.red),
                ),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Build Area (Slots)
          DragTarget<_Tile>(
            onAcceptWithDetails: (details) => _moveToBuilt(details.data),
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: _lastCheckCorrect == null
                        ? Colors.grey.shade300
                        : (_lastCheckCorrect! ? Colors.green : Colors.red),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: _builtTiles.isEmpty 
                    ? [Text('Drag letters here', style: TextStyle(color: Colors.grey.shade400))]
                    : _builtTiles.map((t) => _buildBuiltTile(t)).toList(),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Letter bank
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _bankTiles.map((t) => _buildBankTile(t)).toList(),
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
