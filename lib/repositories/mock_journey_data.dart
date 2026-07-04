import '../models/journey.dart';

/// Sample content used until Firestore is connected (see ContentRepository).
/// Mirrors exactly the shape lessons will have in Firestore, so swapping
/// the data source later requires no changes to models or UI.
final Journey mockJourney = Journey.fromJson({
  'version': 1,
  'lessons': [
    {
      'id': 'lesson_001',
      'title': 'Greetings',
      'order': 1,
      'tasks': [
        {
          'id': 't1',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਸ', 'transliteration': 'sa'},
        },
        {
          'id': 't2',
          'type': 'wordSelection',
          'pointsAwarded': 10,
          'content': {
            'word': 'ਕੁੱਤਾ',
            'correctImageUrl': 'assets/images/dog.png',
            'distractorImageUrls': ['assets/images/cat.png', 'assets/images/bird.png'],
          },
        },
      ],
    },
    {
      'id': 'lesson_002',
      'title': 'Animals',
      'order': 2,
      'tasks': [
        {
          'id': 't3',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'imageUrl': 'assets/images/cat.png',
            'targetWord': 'ਬਿੱਲੀ',
            'letterBank': ['ਬਿ', 'ੱ', 'ਲੀ', 'ਮ', 'ਅ'],
          },
        },
        {
          'id': 't4',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', '___', 'ਹਾਂ'],
            'correctWord': 'ਜਾਂਦਾ',
            'options': ['ਜਾਂਦਾ', 'ਖਾਂਦਾ', 'ਸੌਂਦਾ'],
          },
        },
      ],
    },
    {
      'id': 'lesson_003',
      'title': 'Simple Sentences',
      'order': 3,
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
      ],
    },
  ],
});
