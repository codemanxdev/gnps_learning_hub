/// Lesson data for "Alphabet Tracing".
/// Part of the app's bundled content store (see `lib/data/journey_data.dart`).
///
/// NOTE ON CHECKPOINTS: coordinates are estimated based on typical Gurmukhi
/// letterform proportions, not verified against this app's actual rendered
/// glyphs. Calibrate each letter by temporarily setting
/// `_checkpointRadius = 20` and the unreached-dot color to `Colors.orange`
/// in TraceTaskWidget, then nudge x/y until dots align with the ink.
final Map<String, dynamic> lessonTracing = {
  'id': 'lesson_tracing',
  'title': 'Alphabet Tracing',
  'order': 1,
  'visible': true,
  'sections': [
    {
      'id': 'section_foundation',
      'title': 'Foundation Sounds',
      'tasks': [
        {
          'id': 'trace_01',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ੳ',
            'transliteration': 'ura',
            'checkpoints': [
              {'x': 0.189, 'y': 0.347},
              {'x': 0.251, 'y': 0.217},
              {'x': 0.348, 'y': 0.114},
              {'x': 0.484, 'y': 0.066},
              {'x': 0.638, 'y': 0.068},
              {'x': 0.769, 'y': 0.127},
              {'x': 0.834, 'y': 0.221},
              {'x': 0.856, 'y': 0.331},
              {'x': 0.829, 'y': 0.456},
              {'x': 0.752, 'y': 0.530},
              {'x': 0.638, 'y': 0.601},
              {'x': 0.438, 'y': 0.618},
              {'x': 0.319, 'y': 0.615},
              {'x': 0.242, 'y': 0.622},
              {'x': 0.152, 'y': 0.607},
              {'x': 0.491, 'y': 0.633},
              {'x': 0.644, 'y': 0.658},
              {'x': 0.740, 'y': 0.719},
              {'x': 0.738, 'y': 0.880},
              {'x': 0.580, 'y': 0.943},
              {'x': 0.355, 'y': 0.924},
              {'x': 0.172, 'y': 0.716},
              {'x': 0.150, 'y': 0.651},
              {'x': 0.152, 'y': 0.511},
              {'x': 0.174, 'y': 0.395},
              {'x': 0.191, 'y': 0.332},
              {'x': 0.065, 'y': 0.341},
              {'x': 0.324, 'y': 0.341},
              {'x': 0.486, 'y': 0.338},
              {'x': 0.779, 'y': 0.338},
              {'x': 0.868, 'y': 0.345},
              {'x': 0.956, 'y': 0.332},
            ],
          },
        },
        {
          'id': 'trace_02',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਅ',
            'transliteration': 'aira',
            'checkpoints': [
              {'x': 0.020, 'y': 0.080},
              {'x': 0.193, 'y': 0.080},
              {'x': 0.221, 'y': 0.291},
              {'x': 0.225, 'y': 0.505},
              {'x': 0.157, 'y': 0.615},
              {'x': 0.105, 'y': 0.525},
              {'x': 0.168, 'y': 0.402},
              {'x': 0.314, 'y': 0.285},
              {'x': 0.486, 'y': 0.185},
              {'x': 0.533, 'y': 0.490},
              {'x': 0.530, 'y': 0.687},
              {'x': 0.462, 'y': 0.789},
              {'x': 0.423, 'y': 0.670},
              {'x': 0.507, 'y': 0.554},
              {'x': 0.724, 'y': 0.387},
              {'x': 0.814, 'y': 0.343},
              {'x': 0.812, 'y': 0.935},
              {'x': 0.831, 'y': 0.052},
              {'x': 0.973, 'y': 0.045},
            ],
          },
        },
        {
          'id': 'trace_03',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ੲ',
            'transliteration': 'iri',
            'checkpoints': [
              {'x': 0.55, 'y': 0.15},
              {'x': 0.40, 'y': 0.35},
              {'x': 0.35, 'y': 0.60},
              {'x': 0.45, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_04',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਸ',
            'transliteration': 'sa',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.30, 'y': 0.40},
              {'x': 0.40, 'y': 0.60},
              {'x': 0.60, 'y': 0.70},
              {'x': 0.55, 'y': 0.88},
            ],
          },
        },
        {
          'id': 'trace_05',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਹ',
            'transliteration': 'ha',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.35, 'y': 0.50},
              {'x': 0.45, 'y': 0.65},
              {'x': 0.60, 'y': 0.60},
              {'x': 0.62, 'y': 0.85},
            ],
          },
        },
      ],
    },
    {
      'id': 'section_guttural',
      'title': 'Guttural Sounds',
      'tasks': [
        {
          'id': 'trace_06',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਕ',
            'transliteration': 'ka',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.35, 'y': 0.55},
              {'x': 0.45, 'y': 0.75},
              {'x': 0.65, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_07',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਖ',
            'transliteration': 'kha',
            'checkpoints': [
              {'x': 0.40, 'y': 0.15},
              {'x': 0.35, 'y': 0.40},
              {'x': 0.45, 'y': 0.55},
              {'x': 0.55, 'y': 0.70},
              {'x': 0.50, 'y': 0.88},
            ],
          },
        },
        {
          'id': 'trace_08',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਗ',
            'transliteration': 'ga',
            'checkpoints': [
              {'x': 0.35, 'y': 0.20},
              {'x': 0.55, 'y': 0.15},
              {'x': 0.35, 'y': 0.45},
              {'x': 0.35, 'y': 0.75},
              {'x': 0.50, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_09',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਘ',
            'transliteration': 'gha',
            'checkpoints': [
              {'x': 0.30, 'y': 0.20},
              {'x': 0.35, 'y': 0.45},
              {'x': 0.50, 'y': 0.55},
              {'x': 0.65, 'y': 0.65},
              {'x': 0.60, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_10',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਙ',
            'transliteration': 'nga',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.35, 'y': 0.50},
              {'x': 0.50, 'y': 0.70},
              {'x': 0.65, 'y': 0.55},
              {'x': 0.68, 'y': 0.85},
            ],
          },
        },
      ],
    },
    {
      'id': 'section_palatal',
      'title': 'Palatal Sounds',
      'tasks': [
        {
          'id': 'trace_11',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਚ',
            'transliteration': 'cha',
            'checkpoints': [
              {'x': 0.35, 'y': 0.20},
              {'x': 0.30, 'y': 0.45},
              {'x': 0.45, 'y': 0.65},
              {'x': 0.65, 'y': 0.60},
              {'x': 0.62, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_12',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਛ',
            'transliteration': 'chha',
            'checkpoints': [
              {'x': 0.45, 'y': 0.12},
              {'x': 0.35, 'y': 0.35},
              {'x': 0.35, 'y': 0.60},
              {'x': 0.50, 'y': 0.75},
              {'x': 0.65, 'y': 0.65},
            ],
          },
        },
        {
          'id': 'trace_13',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਜ',
            'transliteration': 'ja',
            'checkpoints': [
              {'x': 0.30, 'y': 0.20},
              {'x': 0.50, 'y': 0.15},
              {'x': 0.55, 'y': 0.50},
              {'x': 0.45, 'y': 0.75},
              {'x': 0.30, 'y': 0.82},
            ],
          },
        },
        {
          'id': 'trace_14',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਝ',
            'transliteration': 'jha',
            'checkpoints': [
              {'x': 0.30, 'y': 0.15},
              {'x': 0.45, 'y': 0.35},
              {'x': 0.35, 'y': 0.55},
              {'x': 0.55, 'y': 0.70},
              {'x': 0.50, 'y': 0.88},
            ],
          },
        },
        {
          'id': 'trace_15',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਞ',
            'transliteration': 'nya',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.35, 'y': 0.45},
              {'x': 0.50, 'y': 0.60},
              {'x': 0.65, 'y': 0.50},
              {'x': 0.65, 'y': 0.82},
            ],
          },
        },
      ],
    },
    {
      'id': 'section_retroflex',
      'title': 'Retroflex Sounds',
      'tasks': [
        {
          'id': 'trace_16',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਟ',
            'transliteration': 'tta',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.35, 'y': 0.50},
              {'x': 0.50, 'y': 0.75},
              {'x': 0.68, 'y': 0.65},
            ],
          },
        },
        {
          'id': 'trace_17',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਠ',
            'transliteration': 'ttha',
            'checkpoints': [
              {'x': 0.40, 'y': 0.15},
              {'x': 0.35, 'y': 0.40},
              {'x': 0.45, 'y': 0.55},
              {'x': 0.60, 'y': 0.70},
              {'x': 0.52, 'y': 0.88},
            ],
          },
        },
        {
          'id': 'trace_18',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਡ',
            'transliteration': 'dda',
            'checkpoints': [
              {'x': 0.35, 'y': 0.20},
              {'x': 0.55, 'y': 0.15},
              {'x': 0.35, 'y': 0.45},
              {'x': 0.35, 'y': 0.75},
              {'x': 0.52, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_19',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਢ',
            'transliteration': 'ddha',
            'checkpoints': [
              {'x': 0.30, 'y': 0.20},
              {'x': 0.35, 'y': 0.45},
              {'x': 0.50, 'y': 0.55},
              {'x': 0.65, 'y': 0.65},
              {'x': 0.58, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_20',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਣ',
            'transliteration': 'nna',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.35, 'y': 0.55},
              {'x': 0.50, 'y': 0.70},
              {'x': 0.65, 'y': 0.55},
              {'x': 0.70, 'y': 0.88},
            ],
          },
        },
      ],
    },
    {
      'id': 'section_dental',
      'title': 'Dental Sounds',
      'tasks': [
        {
          'id': 'trace_21',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਤ',
            'transliteration': 'ta',
            'checkpoints': [
              {'x': 0.30, 'y': 0.20},
              {'x': 0.55, 'y': 0.18},
              {'x': 0.45, 'y': 0.50},
              {'x': 0.35, 'y': 0.75},
              {'x': 0.45, 'y': 0.88},
            ],
          },
        },
        {
          'id': 'trace_22',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਥ',
            'transliteration': 'tha',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.32, 'y': 0.45},
              {'x': 0.45, 'y': 0.60},
              {'x': 0.62, 'y': 0.55},
              {'x': 0.55, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_23',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਦ',
            'transliteration': 'da',
            'checkpoints': [
              {'x': 0.35, 'y': 0.20},
              {'x': 0.30, 'y': 0.45},
              {'x': 0.42, 'y': 0.65},
              {'x': 0.60, 'y': 0.60},
              {'x': 0.55, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_24',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਧ',
            'transliteration': 'dha',
            'checkpoints': [
              {'x': 0.32, 'y': 0.18},
              {'x': 0.50, 'y': 0.15},
              {'x': 0.45, 'y': 0.45},
              {'x': 0.35, 'y': 0.70},
              {'x': 0.50, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_25',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਨ',
            'transliteration': 'na',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.35, 'y': 0.55},
              {'x': 0.48, 'y': 0.75},
              {'x': 0.65, 'y': 0.65},
              {'x': 0.68, 'y': 0.85},
            ],
          },
        },
      ],
    },
    {
      'id': 'section_labial',
      'title': 'Labial Sounds',
      'tasks': [
        {
          'id': 'trace_26',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਪ',
            'transliteration': 'pa',
            'checkpoints': [
              {'x': 0.32, 'y': 0.15},
              {'x': 0.32, 'y': 0.50},
              {'x': 0.45, 'y': 0.75},
              {'x': 0.65, 'y': 0.70},
            ],
          },
        },
        {
          'id': 'trace_27',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਫ',
            'transliteration': 'pha',
            'checkpoints': [
              {'x': 0.30, 'y': 0.15},
              {'x': 0.30, 'y': 0.45},
              {'x': 0.45, 'y': 0.55},
              {'x': 0.62, 'y': 0.68},
              {'x': 0.55, 'y': 0.88},
            ],
          },
        },
        {
          'id': 'trace_28',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਬ',
            'transliteration': 'ba',
            'checkpoints': [
              {'x': 0.30, 'y': 0.15},
              {'x': 0.32, 'y': 0.50},
              {'x': 0.32, 'y': 0.80},
              {'x': 0.55, 'y': 0.85},
              {'x': 0.65, 'y': 0.60},
            ],
          },
        },
        {
          'id': 'trace_29',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਭ',
            'transliteration': 'bha',
            'checkpoints': [
              {'x': 0.30, 'y': 0.15},
              {'x': 0.30, 'y': 0.50},
              {'x': 0.45, 'y': 0.65},
              {'x': 0.60, 'y': 0.55},
              {'x': 0.55, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_30',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਮ',
            'transliteration': 'ma',
            'checkpoints': [
              {'x': 0.28, 'y': 0.15},
              {'x': 0.28, 'y': 0.80},
              {'x': 0.45, 'y': 0.50},
              {'x': 0.62, 'y': 0.80},
              {'x': 0.65, 'y': 0.15},
            ],
          },
        },
      ],
    },
    {
      'id': 'section_semivowels',
      'title': 'Semivowels',
      'tasks': [
        {
          'id': 'trace_31',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਯ',
            'transliteration': 'ya',
            'checkpoints': [
              {'x': 0.30, 'y': 0.15},
              {'x': 0.30, 'y': 0.55},
              {'x': 0.45, 'y': 0.75},
              {'x': 0.60, 'y': 0.60},
              {'x': 0.65, 'y': 0.88},
            ],
          },
        },
        {
          'id': 'trace_32',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਰ',
            'transliteration': 'ra',
            'checkpoints': [
              {'x': 0.35, 'y': 0.20},
              {'x': 0.32, 'y': 0.50},
              {'x': 0.45, 'y': 0.70},
              {'x': 0.65, 'y': 0.55},
            ],
          },
        },
        {
          'id': 'trace_33',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਲ',
            'transliteration': 'la',
            'checkpoints': [
              {'x': 0.45, 'y': 0.12},
              {'x': 0.40, 'y': 0.40},
              {'x': 0.35, 'y': 0.65},
              {'x': 0.50, 'y': 0.82},
              {'x': 0.65, 'y': 0.70},
            ],
          },
        },
        {
          'id': 'trace_34',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ਵ',
            'transliteration': 'va',
            'checkpoints': [
              {'x': 0.35, 'y': 0.20},
              {'x': 0.30, 'y': 0.50},
              {'x': 0.42, 'y': 0.70},
              {'x': 0.60, 'y': 0.60},
              {'x': 0.58, 'y': 0.85},
            ],
          },
        },
        {
          'id': 'trace_35',
          'type': 'trace',
          'pointsAwarded': 10,
          'content': {
            'letter': 'ੜ',
            'transliteration': 'rra',
            'checkpoints': [
              {'x': 0.35, 'y': 0.15},
              {'x': 0.32, 'y': 0.50},
              {'x': 0.45, 'y': 0.70},
              {'x': 0.65, 'y': 0.55},
              {'x': 0.60, 'y': 0.88},
            ],
          },
        },
      ],
    },
  ],
};
