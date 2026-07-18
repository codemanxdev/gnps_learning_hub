import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/task.dart';
import 'package:gnps_learning_hub/widgets/tasks/word_selection_task_widget.dart';

void main() {
  final testTask = Task(
    id: 't4',
    type: TaskType.wordSelection,
    pointsAwarded: 10,
    content: {
      'word': 'ਸੇਬ',
      'correctEmoji': '🍎',
      'distractorEmojis': ['🍌', '🍊', '🍇'],
    },
  );

  testWidgets('WordSelectionTaskWidget should render word and emojis', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: WordSelectionTaskWidget(
              task: testTask,
              onComplete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Select the correct picture'), findsOneWidget);
    expect(find.text('ਸੇਬ'), findsOneWidget);
    expect(find.text('🍎'), findsOneWidget);
  });
}
