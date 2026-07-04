import 'task.dart';

class Lesson {
  final String id;
  final String title;
  final int order;
  final List<Task> tasks;

  const Lesson({
    required this.id,
    required this.title,
    required this.order,
    required this.tasks,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final rawTasks = (json['tasks'] as List).cast<Map>();
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
      tasks: rawTasks
          .map((t) => Task.fromJson(Map<String, dynamic>.from(t)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'order': order,
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };
}
