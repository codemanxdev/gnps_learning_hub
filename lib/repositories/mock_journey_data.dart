import '../models/journey.dart';

/// Sample content used until Firestore is connected (see ContentRepository).
/// Mirrors exactly the shape lessons will have in Firestore, so swapping
/// the data source later requires no changes to models or UI.
///
/// Lesson order: the Gurmukhi alphabet (ਪੈਂਤੀ) comes first, grouped into
/// 7 lessons of 5 letters each following the traditional phonetic groups
/// (vargas) — foundation sounds, then guttural/palatal/retroflex/dental/
/// labial groups, then semivowels. Vocabulary lessons come after, since
/// they build on letters the child has already traced. Word-selection
/// (picture matching) tasks follow immediately after, reinforcing the
/// same vocabulary through recognition rather than recall. Fill-in-the-
/// blank tasks are grouped into their own dedicated lesson (rather than
/// mixed into letter/vocabulary lessons) so the task type gets focused
/// practice once the child has the vocabulary to draw on. Sentence-
/// arrangement lessons come last, as the most advanced task type.
///
/// Each lesson carries a `visible` flag (default true) and an `order`
/// used for journey-map placement. Set `visible: false` to hide a lesson
/// entirely (e.g. content still being reviewed) without deleting it or
/// renumbering later lessons.
final Journey mockJourney = Journey.fromJson({
  'version': 2,
  'lessons': [
    {
      'id': 'lesson_letters_01',
      'title': 'Foundation Sounds',
      'order': 1,
      'visible': true,
      'tasks': [
        {
          'id': 'trace_01',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ੳ', 'transliteration': 'ura'},
        },
        {
          'id': 'trace_02',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਅ', 'transliteration': 'aira'},
        },
        {
          'id': 'trace_03',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ੲ', 'transliteration': 'iri'},
        },
        {
          'id': 'trace_04',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਸ', 'transliteration': 'sa'},
        },
        {
          'id': 'trace_05',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਹ', 'transliteration': 'ha'},
        },
      ],
    },
    {
      'id': 'lesson_letters_02',
      'title': 'Guttural Sounds',
      'order': 2,
      'visible': true,
      'tasks': [
        {
          'id': 'trace_06',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਕ', 'transliteration': 'ka'},
        },
        {
          'id': 'trace_07',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਖ', 'transliteration': 'kha'},
        },
        {
          'id': 'trace_08',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਗ', 'transliteration': 'ga'},
        },
        {
          'id': 'trace_09',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਘ', 'transliteration': 'gha'},
        },
        {
          'id': 'trace_10',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਙ', 'transliteration': 'nga'},
        },
      ],
    },
    {
      'id': 'lesson_letters_03',
      'title': 'Palatal Sounds',
      'order': 3,
      'visible': false,
      'tasks': [
        {
          'id': 'trace_11',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਚ', 'transliteration': 'cha'},
        },
        {
          'id': 'trace_12',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਛ', 'transliteration': 'chha'},
        },
        {
          'id': 'trace_13',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਜ', 'transliteration': 'ja'},
        },
        {
          'id': 'trace_14',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਝ', 'transliteration': 'jha'},
        },
        {
          'id': 'trace_15',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਞ', 'transliteration': 'nya'},
        },
      ],
    },
    {
      'id': 'lesson_letters_04',
      'title': 'Retroflex Sounds',
      'order': 4,
      'visible': false,
      'tasks': [
        {
          'id': 'trace_16',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਟ', 'transliteration': 'tta'},
        },
        {
          'id': 'trace_17',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਠ', 'transliteration': 'ttha'},
        },
        {
          'id': 'trace_18',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਡ', 'transliteration': 'dda'},
        },
        {
          'id': 'trace_19',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਢ', 'transliteration': 'ddha'},
        },
        {
          'id': 'trace_20',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਣ', 'transliteration': 'nna'},
        },
      ],
    },
    {
      'id': 'lesson_letters_05',
      'title': 'Dental Sounds',
      'order': 5,
      'visible': true,
      'tasks': [
        {
          'id': 'trace_21',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਤ', 'transliteration': 'ta'},
        },
        {
          'id': 'trace_22',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਥ', 'transliteration': 'tha'},
        },
        {
          'id': 'trace_23',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਦ', 'transliteration': 'da'},
        },
        {
          'id': 'trace_24',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਧ', 'transliteration': 'dha'},
        },
        {
          'id': 'trace_25',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਨ', 'transliteration': 'na'},
        },
      ],
    },
    {
      'id': 'lesson_letters_06',
      'title': 'Labial Sounds',
      'order': 6,
      'visible': false,
      'tasks': [
        {
          'id': 'trace_26',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਪ', 'transliteration': 'pa'},
        },
        {
          'id': 'trace_27',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਫ', 'transliteration': 'pha'},
        },
        {
          'id': 'trace_28',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਬ', 'transliteration': 'ba'},
        },
        {
          'id': 'trace_29',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਭ', 'transliteration': 'bha'},
        },
        {
          'id': 'trace_30',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਮ', 'transliteration': 'ma'},
        },
      ],
    },
    {
      'id': 'lesson_letters_07',
      'title': 'Semivowels',
      'order': 7,
      'visible': false,
      'tasks': [
        {
          'id': 'trace_31',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਯ', 'transliteration': 'ya'},
        },
        {
          'id': 'trace_32',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਰ', 'transliteration': 'ra'},
        },
        {
          'id': 'trace_33',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਲ', 'transliteration': 'la'},
        },
        {
          'id': 'trace_34',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {'letter': 'ਵ', 'transliteration': 'va'},
        },
        {
          'id': 'trace_35',
          'type': 'trace',
          'pointsAwarded': 10,
          // still validating stroke recognition for this letter's shape
          'content': {'letter': 'ੜ', 'transliteration': 'rra'},
        },
      ],
    },
    {
      'id': 'lesson_002',
      'title': 'Animals',
      'order': 8,
      'visible': true,
      'tasks': [
        {
          'id': 't3',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐈',
            'targetWord': 'ਬਿੱਲੀ',
            'letterBank': ['ਬਿ', 'ੱ', 'ਲੀ', 'ਮ', 'ਅ'],
          },
        },
        {
          'id': 't6',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐕',
            'targetWord': 'ਕੁੱਤਾ',
            'letterBank': ['ਕੁ', 'ੱ', 'ਤਾ', 'ਬ', 'ਲੀ'],
          },
        },
        {
          'id': 't9',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '📖',
            'targetWord': 'ਕਿਤਾਬ',
            'letterBank': ['ਕਿ', 'ਤਾ', 'ਬ', 'ਮੇਰੀ', 'ਸਕੂਲ'],
          },
        },
        {
          'id': 'spelling_01',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '☀️',
            'targetWord': 'ਸੂਰਜ',
            'letterBank': ['ਸੂ', 'ਰ', 'ਜ', 'ਹ', 'ਅ'],
          },
        },
        {
          'id': 'spelling_02',
          'type': 'spelling',
          'pointsAwarded': 15,
          'content': {
            'emoji': '🐦',
            'targetWord': 'ਚਿੜੀ',
            'letterBank': ['ਚ', 'ਿ', 'ੜ', 'ੀ', 'ਗ', 'ਖ', 'ਘ'],
          },
        },
      ],
    },
    {
      'id': 'lesson_word_selection',
      'title': 'Match the Word',
      'order': 9,
      'visible': true,
      'tasks': [
        {
          'id': 'wordSelect_01',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਬਿੱਲੀ',
            'correctEmoji': '🐈',
            'distractorEmojis': ['🐕', '📖', '☀️'],
          },
        },
        {
          'id': 'wordSelect_02',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕੁੱਤਾ',
            'correctEmoji': '🐕',
            'distractorEmojis': ['🐈', '🐦', '☀️'],
          },
        },
        {
          'id': 'wordSelect_03',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਕਿਤਾਬ',
            'correctEmoji': '📖',
            'distractorEmojis': ['🐈', '🐕', '🐦'],
          },
        },
        {
          'id': 'wordSelect_04',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਸੂਰਜ',
            'correctEmoji': '☀️',
            'distractorEmojis': ['🐦', '📖', '🐕'],
          },
        },
        {
          'id': 'wordSelect_05',
          'type': 'wordSelection',
          'pointsAwarded': 15,
          'content': {
            'word': 'ਚਿੜੀ',
            'correctEmoji': '🐦',
            'distractorEmojis': ['🐈', '☀️', '📖'],
          },
        },
      ],
    },
    {
      'id': 'lesson_fill_in_blanks',
      'title': 'Fill in the Blanks',
      'order': 10,
      'visible': true,
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
          'id': 't4',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਮੈਂ', '___', 'ਹਾਂ'],
            'correctWord': 'ਜਾਂਦਾ',
            'options': ['ਜਾਂਦਾ', 'ਖਾਂਦਾ', 'ਸੌਂਦਾ'],
          },
        },
        {
          'id': 't7',
          'type': 'fillInBlank',
          'pointsAwarded': 15,
          'content': {
            'sentenceParts': ['ਇਹ', '___', 'ਹੈ'],
            'correctWord': 'ਗਾਂ',
            'options': ['ਗਾਂ', 'ਕੁੱਤਾ', 'ਬਿੱਲੀ'],
          },
        },
      ],
    },
    {
      'id': 'lesson_003',
      'title': 'Simple Sentences',
      'order': 11,
      'visible': true,
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
          'id': 't8',
          'type': 'arrangeSentence',
          'pointsAwarded': 20,
          'content': {
            'words': ['ਇਹ', 'ਮੇਰੀ', 'ਕਿਤਾਬ', 'ਹੈ'],
            'correctOrder': [0, 1, 2, 3],
          },
        },
      ],
    },
  ],
});
