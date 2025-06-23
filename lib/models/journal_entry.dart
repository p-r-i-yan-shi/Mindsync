class JournalEntry {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String? voiceText;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.voiceText,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'voiceText': voiceText,
      };

  factory JournalEntry.fromMap(Map<String, dynamic> map) => JournalEntry(
        id: map['id'] as String,
        userId: map['userId'] as String,
        content: map['content'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        voiceText: map['voiceText'] as String?,
      );
} 