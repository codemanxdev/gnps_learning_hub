/// Configuration for the "Letter Bubbles" game.
final Map<String, dynamic> bubbleGameConfig = {
  'id': 'bubble_pop_letters',
  'title': 'Letter Bubbles',
  'unlockAfterLessonId': 'lesson_tracing',
  'type': 'bubble_pop',
  'mapXOffset': 150.0,
  'mapYOffset': 80.0,
  'iconName': 'bubble',
  'colorValue': 0xFF2196F3, // Colors.blue
  'content': {
    'spawnRateMs': 800,
    'minSpeed': 1.0,
    'maxSpeed': 2.5,
    'bubbleSize': 120.0,
    'letters': [
      'ੳ', 'ਅ', 'ੲ', 'ਸ', 'ਹ',
      'ਕ', 'ਖ', 'ਗ', 'ਘ', 'ਙ',
      'ਚ', 'ਛ', 'ਜ', 'ਝ', 'ਞ',
      'ਟ', 'ਠ', 'ਡ', 'ਢ', 'ਣ',
      'ਤ', 'ਥ', 'ਦ', 'ਧ', 'ਨ',
      'ਪ', 'ਫ', 'ਬ', 'ਭ', 'ਮ',
      'ਯ', 'ਰ', 'ਲ', 'ਵ', 'ੜ'
    ],
  },
};
