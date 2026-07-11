import 'shop_item.dart';

class LocalProgress {
  int totalPoints;
  int currentStreak;
  DateTime? lastActiveDate;
  Set<String> completedLessonIds;
  Set<String> completedSectionIds;
  Set<String> unlockedLessonIds;
  Map<String, int> ownedItemQuantities;
  Map<String, String> equippedItemIds;

  static const Map<AvatarSlot, String> defaultEquippedItemIds = {
    AvatarSlot.base: 'avatar_base_default',
    AvatarSlot.turban: 'turban_none',
    AvatarSlot.clothes: 'clothes_default',
    AvatarSlot.accessory: 'accessory_none',
  };

  LocalProgress({
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.lastActiveDate,
    Set<String>? completedLessonIds,
    Set<String>? completedSectionIds,
    Set<String>? unlockedLessonIds,
    Map<String, int>? ownedItemQuantities,
    Map<String, String>? equippedItemIds,
  }) : completedLessonIds = completedLessonIds ?? {},
       completedSectionIds = completedSectionIds ?? {},
       unlockedLessonIds = unlockedLessonIds ?? {},
       ownedItemQuantities = ownedItemQuantities ?? {},
       equippedItemIds =
           equippedItemIds ??
           defaultEquippedItemIds.map(
             (slot, itemId) => MapEntry(slot.name, itemId),
           );

  factory LocalProgress.fromJson(Map<String, dynamic> json) {
    return LocalProgress(
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String)
          : null,
      completedLessonIds: Set<String>.from(
        json['completedLessonIds'] as List? ?? [],
      ),
      completedSectionIds: Set<String>.from(
        json['completedSectionIds'] as List? ?? [],
      ),
      unlockedLessonIds: Set<String>.from(
        json['unlockedLessonIds'] as List? ?? [],
      ),
      ownedItemQuantities: Map<String, int>.from(
        (json['ownedItemQuantities'] as Map?)?.map(
              (key, value) => MapEntry(key as String, (value as num).toInt()),
            ) ??
            {},
      ),
      equippedItemIds: {
        ...defaultEquippedItemIds.map(
          (slot, itemId) => MapEntry(slot.name, itemId),
        ),
        ...Map<String, String>.from(
          (json['equippedItemIds'] as Map?)?.map(
                (key, value) => MapEntry(key as String, value as String),
              ) ??
              {},
        ),
      },
    );
  }

  Map<String, dynamic> toJson() => {
    'totalPoints': totalPoints,
    'currentStreak': currentStreak,
    'lastActiveDate': lastActiveDate?.toIso8601String(),
    'completedLessonIds': completedLessonIds.toList(),
    'completedSectionIds': completedSectionIds.toList(),
    'unlockedLessonIds': unlockedLessonIds.toList(),
    'ownedItemQuantities': ownedItemQuantities,
    'equippedItemIds': equippedItemIds,
  };
}
