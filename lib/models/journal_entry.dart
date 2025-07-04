import 'package:flutter/material.dart';

// Mood enumeration
enum Mood { happy, neutral, sad, angry, excited, calm }

// Extension to get icon and color for Mood
extension MoodDetails on Mood {
  IconData get icon {
    switch (this) {
      case Mood.happy:
        return Icons.sentiment_satisfied_alt;
      case Mood.neutral:
        return Icons.sentiment_neutral;
      case Mood.sad:
        return Icons.sentiment_dissatisfied;
      case Mood.angry:
        return Icons.sentiment_very_dissatisfied;
      case Mood.excited:
        return Icons.local_fire_department;
      case Mood.calm:
        return Icons.self_improvement;
    }
  }

  Color getColor(BuildContext context) {
    switch (this) {
      case Mood.happy:
        return Colors.green.shade400;
      case Mood.neutral:
        return Colors.grey.shade400;
      case Mood.sad:
        return Colors.blue.shade400;
      case Mood.angry:
        return Colors.red.shade400;
      case Mood.excited:
        return Colors.orange.shade400;
      case Mood.calm:
        return Colors.purple.shade400;
    }
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }
}

class JournalEntry {
  final String id;
  String title;
  String content;
  Mood mood;
  DateTime timestamp;
  bool isFavorite;
  bool isDeleted;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.timestamp,
    this.isFavorite = false,
    this.isDeleted = false,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      mood: Mood.values.firstWhere(
        (Mood e) => e.toString() == 'Mood.${map['mood']}',
      ),
      timestamp: DateTime.parse(map['timestamp'] as String),
      isFavorite: map['isFavorite'] as bool? ?? false,
      isDeleted: map['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'mood': mood.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
      'isDeleted': isDeleted,
    };
  }

  JournalEntry copyWith({
    String? title,
    String? content,
    Mood? mood,
    DateTime? timestamp,
    bool? isFavorite,
    bool? isDeleted,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
} 