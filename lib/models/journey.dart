import 'lesson.dart';

class Journey {
  final int version;
  final List<Lesson> lessons;

  const Journey({required this.version, required this.lessons});

  /// Lessons with `visible == true`, already in `order`. Use this instead
  /// of `lessons` anywhere the journey map is built, so a hidden lesson is
  /// fully invisible rather than shown greyed-out or locked.
  List<Lesson> get activeLessons => lessons.where((l) => l.visible).toList();

  factory Journey.fromJson(Map<String, dynamic> json) {
    final rawLessons = (json['lessons'] as List).cast<Map>();
    final lessons =
        rawLessons
            .map((l) => Lesson.fromJson(Map<String, dynamic>.from(l)))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    return Journey(version: (json['version'] as num).toInt(), lessons: lessons);
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'lessons': lessons.map((l) => l.toJson()).toList(),
  };
}
