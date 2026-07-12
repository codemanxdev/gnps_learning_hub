/// Lesson data for "Match the Word".
/// Part of the app's bundled content store (see `lib/data/journey_data.dart`).
final Map<String, dynamic> lessonMatching = {
  'id': 'lesson_matching',
  'title': 'Match the Word',
  'order': 3,
  'visible': false,
  'sections': [
    {
      'id': 'section_matching_animals',
      'title': 'Animals',
      'tasks': [
        {
          'id': 'wordSelect_01',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਿੱਲੀ',
            'correctEmoji': '🐱',
            'distractorEmojis': ['🦮', '📖', '☀️'],
          },
        },
        {
          'id': 'wordSelect_02',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੁੱਤਾ',
            'correctEmoji': '🦮',
            'distractorEmojis': ['🐱', '🐟', '🐴'],
          },
        },
        {
          'id': 'wordSelect_03',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਮੱਛੀ',
            'correctEmoji': '🐟',
            'distractorEmojis': ['🐘', '🐱', '🦮'],
          },
        },
      ],
    },
    {
      'id': 'section_matching_colors',
      'title': 'Colors',
      'tasks': [
        {
          'id': 'wordSelect_04',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਲਾਲ',
            'correctEmoji': '🔴',
            'distractorEmojis': ['🔵', '🟡', '🟢'],
          },
        },
        {
          'id': 'wordSelect_05',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਹਰਾ',
            'correctEmoji': '🟢',
            'distractorEmojis': ['⚫', '⚪', '🔵'],
          },
        },
      ],
    },
  ],
};
