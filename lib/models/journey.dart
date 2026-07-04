import 'lesson.dart';

class Journey {
  final int version;
  final List<Lesson> lessons;

  const Journey({required this.version, required this.lessons});

  factory Journey.fromJson(Map<String, dynamic> json) {
    final rawLessons = (json['lessons'] as List).cast<Map>();
    final lessons = rawLessons
        .map((l) => Lesson.fromJson(Map<String, dynamic>.from(l)))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return Journey(
      version: (json['version'] as num).toInt(),
      lessons: lessons,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'lessons': lessons.map((l) => l.toJson()).toList(),
      };
}
