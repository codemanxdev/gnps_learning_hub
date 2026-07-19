// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/data/journey_data.dart';

void main() {
  test('Generate CURRICULUM.md', () {
    final buffer = StringBuffer();
    buffer.writeln('# GNPS Learning Hub - Curriculum Overview');
    buffer.writeln();
    buffer.writeln('This document is automatically generated from the app\'s lesson data.');
    buffer.writeln();
    buffer.writeln('## 🎓 Learning Journey');
    buffer.writeln();

    for (var i = 0; i < journeyData.lessons.length; i++) {
      final lesson = journeyData.lessons[i];
      buffer.writeln('### ${i + 1}. ${lesson.title}');
      
      // Attempt to find a description from common patterns (optional)
      if (lesson.id == 'lesson_tracing') {
        buffer.writeln('*Master the strokes of the Gurmukhi script.*');
      } else if (lesson.id == 'lesson_letter_selection') {
        buffer.writeln('*Practice auditory recognition and matching of Punjabi letters.*');
      }

      for (final section in lesson.sections) {
        buffer.writeln('- **${section.title}**');
      }
      buffer.writeln();
    }

    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln('## 🕹️ Arcade Games');
    buffer.writeln();

    for (final game in journeyData.games) {
      buffer.writeln('- **${game.title}**: ${game.type.replaceAll('_', ' ')} game unlocked after `${game.unlockAfterLessonId}`.');
    }

    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln('### 🛠️ Maintenance');
    buffer.writeln('To refresh this document after modifying lesson data, run:');
    buffer.writeln('```bash');
    buffer.writeln('flutter test test/tools/generate_curriculum_test.dart');
    buffer.writeln('```');
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln('*Last Updated: ${DateTime.now().toString().split(' ')[0]}*');

    final file = File('CURRICULUM.md');
    file.writeAsStringSync(buffer.toString());
    
    print('✅ CURRICULUM.md has been refreshed!');
  });
}
