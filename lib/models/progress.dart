class LocalProgress {
  int totalPoints;
  int currentStreak;
  DateTime? lastActiveDate;
  Set<String> completedLessonIds;
  Set<String> unlockedLessonIds;

  LocalProgress({
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.lastActiveDate,
    Set<String>? completedLessonIds,
    Set<String>? unlockedLessonIds,
  })  : completedLessonIds = completedLessonIds ?? {},
        unlockedLessonIds = unlockedLessonIds ?? {};

  factory LocalProgress.fromJson(Map<String, dynamic> json) {
    return LocalProgress(
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String)
          : null,
      completedLessonIds:
          Set<String>.from(json['completedLessonIds'] as List? ?? []),
      unlockedLessonIds:
          Set<String>.from(json['unlockedLessonIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalPoints': totalPoints,
        'currentStreak': currentStreak,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
        'completedLessonIds': completedLessonIds.toList(),
        'unlockedLessonIds': unlockedLessonIds.toList(),
      };
}
