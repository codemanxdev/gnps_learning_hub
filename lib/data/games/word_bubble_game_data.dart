/// Configuration for the "Word Bubbles" game.
final Map<String, dynamic> wordBubbleGameConfig = {
  'id': 'bubble_pop_words',
  'title': 'Word Bubbles',
  'unlockAfterLessonId': 'lesson_arrange_sentence',
  'type': 'bubble_pop',
  'mapXOffset': -110.0, // Tucked into the left tree line
  'mapYOffset': -20.0, // Slightly above the lesson node to avoid bottom edge
  'iconName': 'bubble',
  'colorValue': 0xFF9C27B0, // Purple
  'content': {
    'spawnRateMs': 1000,
    'minSpeed': 0.8,
    'maxSpeed': 2.0,
    'bubbleSize': 180.0, // Larger for words
    'letters': [
      'ਸਕੂਲ', 'ਕਿਤਾਬ', 'ਸੇਬ', 'ਦੁੱਧ', 'ਬਿੱਲੀ', 
      'ਗੇਂਦ', 'ਖਾਣਾ', 'ਮਾਂ', 'ਪਿਤਾ', 'ਭਰਾ',
      'ਪਾਣੀ', 'ਰੋਟੀ', 'ਫੁੱਲ', 'ਘਰ', 'ਕੁੱਤਾ'
    ],
  },
};
