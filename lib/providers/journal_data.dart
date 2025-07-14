import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class JournalData extends ChangeNotifier {
  final List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => List<JournalEntry>.unmodifiable(_entries);

  void addEntry(JournalEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  int get totalEntries => _entries.length;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<DateTime, int> getMoodsForLastNDays(int n) {
    final Map<DateTime, int> dailyMoods = {};
    final DateTime now = DateTime.now();
    for (int i = 0; i < n; i++) {
      final DateTime day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      dailyMoods[day] = -1;
    }
    for (final JournalEntry entry in _entries) {
      final DateTime entryDay = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
      if (dailyMoods.containsKey(entryDay)) {
        dailyMoods[entryDay] = entry.moodIndex;
      }
    }
    return dailyMoods;
  }

  int get currentStreak {
    if (_entries.isEmpty) {
      return 0;
    }
    int streak = 0;
    DateTime tempDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    bool hasEntryForCurrentDay = _entries.any((JournalEntry entry) => _isSameDay(entry.timestamp, tempDay));
    if (hasEntryForCurrentDay) {
      streak = 1;
      tempDay = tempDay.subtract(const Duration(days: 1));
      while (true) {
        hasEntryForCurrentDay = _entries.any((JournalEntry entry) => _isSameDay(entry.timestamp, tempDay));
        if (hasEntryForCurrentDay) {
          streak++;
          tempDay = tempDay.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }
    return streak;
  }
} 