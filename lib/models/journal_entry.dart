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
  final String text;
  final DateTime timestamp;
  final int moodIndex; // 0: Very Sad, 1: Sad, 2: Happy, 3: Very Happy, 4: Excited

  JournalEntry({required this.text, required this.timestamp, required this.moodIndex});
} 