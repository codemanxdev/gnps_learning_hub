/// Lesson data for "Fill in the Blanks".
/// Part of the app's bundled content store (see `lib/data/journey_data.dart`).
final Map<String, dynamic> lessonFillInBlank = {
  'id': 'lesson_fill_in_blank',
  'title': 'Fill in the Blanks',
  'order': 4,
  'visible': true,
  'sections': [
    {
      'id': 'section_blanks_basic',
      'title': 'Everyday Objects & Animals',
      'tasks': [
        {
          'id': 'fillInBlank_01',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਇਹ', '___', 'ਹੈ'],
            'correctWord': 'ਚਿੜੀ',
            'options': ['ਚਿੜੀ', 'ਗਾਂ', 'ਬਿੱਲੀ'],
          },
        },
        {
          'id': 'fillInBlank_02',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਇਹ', '___', 'ਹੈ'],
            'correctWord': 'ਸੇਬ',
            'options': ['ਸੇਬ', 'ਕਿਤਾਬ', 'ਗੇਂਦ'],
          },
        },
        {
          'id': 'fillInBlank_03',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਇਹ', '___', 'ਹੈ'],
            'correctWord': 'ਘੋੜਾ',
            'options': ['ਘੋੜਾ', 'ਮੱਛੀ', 'ਹਾਥੀ'],
          },
        },
      ],
    },
    {
      'id': 'section_blanks_advanced',
      'title': 'Colors & Family',
      'tasks': [
        {
          'id': 'fillInBlank_04',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੇਰੀ', '___', 'ਦਾ', 'ਨਾਮ', 'ਜਸਲੀਨ', 'ਹੈ'],
            'correctWord': 'ਮਾਂ',
            'options': ['ਮਾਂ', 'ਭਰਾ', 'ਕਿਤਾਬ'],
          },
        },
        {
          'id': 'fillInBlank_05',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਕੁੱਤਾ', '___', 'ਹੈ'],
            'correctWord': 'ਕਾਲਾ',
            'options': ['ਕਾਲਾ', 'ਲਾਲ', 'ਪੀਲਾ'],
          },
        },
      ],
    },
    {
      'id': 'section_family_sentences',
      'title': 'Family Sentences',
      'tasks': [
        {
          'id': 'fillInBlank_06',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੇਰਾ', '___', 'ਸਕੂਲ', 'ਜਾਂਦਾ', 'ਹੈ'],
            'correctWord': 'ਭਰਾ',
            'options': ['ਭਰਾ', 'ਦਾਦੀ ਜੀ', 'ਬਿੱਲੀ'],
          },
        },
        {
          'id': 'fillInBlank_07',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੇਰੀ', '___', 'ਕਿਤਾਬ', 'ਪੜ੍ਹਦੀ', 'ਹੈ'],
            'correctWord': 'ਭੈਣ',
            'options': ['ਭੈਣ', 'ਪਿਤਾ', 'ਗਾਂ'],
          },
        },
      ],
    },
  ],
};
