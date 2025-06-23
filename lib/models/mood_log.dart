class MoodLog {
  final String id;
  final String userId;
  final int mood; // 1 (very sad) to 5 (very happy)
  final String? note;
  final DateTime createdAt;

  MoodLog({
    required this.id,
    required this.userId,
    required this.mood,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'mood': mood,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory MoodLog.fromMap(Map<String, dynamic> map) => MoodLog(
        id: map['id'] as String,
        userId: map['userId'] as String,
        mood: map['mood'] as int,
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
} 