import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task.dart';
import '../../providers.dart';

class ArrangeSentenceTaskWidget extends ConsumerStatefulWidget {
  final Task task;
  final VoidCallback onComplete;

  const ArrangeSentenceTaskWidget({super.key, required this.task, required this.onComplete});

  @override
  ConsumerState<ArrangeSentenceTaskWidget> createState() => _ArrangeSentenceTaskWidgetState();
}

class _ArrangeSentenceTaskWidgetState extends ConsumerState<ArrangeSentenceTaskWidget> {
  late List<_WordTile> _bankTiles;
  final List<_WordTile> _builtTiles = [];
  bool? _lastCheckCorrect;

  @override
  void initState() {
    super.initState();
    final words = List<String>.from(widget.task.content['words'] as List);
    _bankTiles = [
      for (int i = 0; i < words.length; i++) _WordTile(originalIndex: i, text: words[i]),
    ]..shuffle(Random());
  }

  void _moveToBuilt(_WordTile tile) {
    setState(() {
      _bankTiles.remove(tile);
      _builtTiles.add(tile);
      _lastCheckCorrect = null;
    });
  }

  void _moveToBank(_WordTile tile) {
    setState(() {
      _builtTiles.remove(tile);
      _bankTiles.add(tile);
      _lastCheckCorrect = null;
    });
  }

  void _check() {
    final correctOrder = List<int>.from(widget.task.content['correctOrder'] as List);
    final builtOrder = _builtTiles.map((t) => t.originalIndex).toList();
    final isCorrect = builtOrder.length == correctOrder.length &&
        List.generate(builtOrder.length, (i) => builtOrder[i] == correctOrder[i]).every((b) => b);

    setState(() => _lastCheckCorrect = isCorrect);
    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 600), widget.onComplete);
    }
  }

  Widget _buildTile(_WordTile tile, {required bool inBank}) {
    final chip = Card(
      color: inBank ? null : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(tile.text, style: const TextStyle(fontSize: 20)),
      ),
    );
    return Draggable<_WordTile>(
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
    final fullSentence = (List<String>.from(widget.task.content['words'] as List)).join(' ');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Arrange the sentence', style: Theme.of(context).textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => ref.read(audioServiceProvider).speak(fullSentence),
              ),
            ],
          ),
          const SizedBox(height: 24),
          DragTarget<_WordTile>(
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
                  children: _builtTiles.map((t) => _buildTile(t, inBank: false)).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Drag words here in order', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bankTiles.map((t) => _buildTile(t, inBank: true)).toList(),
          ),
          const Spacer(),
          FilledButton(
            onPressed: _builtTiles.isEmpty ? null : _check,
            child: const Text('Check'),
          ),
        ],
      ),
    );
  }
}

class _WordTile {
  final int originalIndex;
  final String text;
  _WordTile({required this.originalIndex, required this.text});
}
