import '../../config/content_ids.dart';

/// Lesson data for "Sentence Arrangement".
/// Part of the app's bundled content store (see `lib/data/journey_data.dart`).
final Map<String, dynamic> lessonArrangeSentence = {
  'id': ContentIds.arrangeSentence,
  'title': 'Sentence Arrangement',
  'order': 7,
  'visible': true,
  'sections': [
    {
      'id': 'section_arrangement_basic',
      'title': 'Everyday Sentences',
      'tasks': [
        {
          'id': 't5',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਮੈਂ', 'ਸਕੂਲ', 'ਜਾਂਦਾ', 'ਹਾਂ'],
            'correctOrder': [0, 1, 2, 3],
          },
        },
        {
          'id': 'arrange_02',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਮੈਂ', 'ਸੇਬ', 'ਖਾਂਦਾ', 'ਹਾਂ'],
            'correctOrder': [0, 1, 2, 3],
          },
        },
        {
          'id': 'arrange_03',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਇਹ', 'ਮੇਰੀ', 'ਕਿਤਾਬ', 'ਹੈ'],
            'correctOrder': [0, 1, 2, 3],
          },
        },
      ],
    },
    {
      'id': 'section_arrangement_advanced',
      'title': 'More Sentences',
      'tasks': [
        {
          'id': 'arrange_04',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਬਿੱਲੀ', 'ਦੁੱਧ', 'ਪੀਂਦੀ', 'ਹੈ'],
            'correctOrder': [0, 1, 2, 3],
          },
        },
        {
          'id': 'arrange_05',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਮੇਰਾ', 'ਭਰਾ', 'ਗੇਂਦ', 'ਖੇਡਦਾ', 'ਹੈ'],
            'correctOrder': [0, 1, 2, 3, 4],
          },
        },
      ],
    },
    {
      'id': 'section_family_arrangement',
      'title': 'Family Sentences',
      'tasks': [
        {
          'id': 'arrange_06',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਮੇਰੀ', 'ਮਾਂ', 'ਖਾਣਾ', 'ਬਣਾਉਂਦੀ', 'ਹੈ'],
            'correctOrder': [0, 1, 2, 3, 4],
          },
        },
        {
          'id': 'arrange_07',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਮੇਰਾ', 'ਪਿਤਾ', 'ਕੰਮ', 'ਕਰਦਾ', 'ਹੈ'],
            'correctOrder': [0, 1, 2, 3, 4],
          },
        },
      ],
    },
  ],
};
