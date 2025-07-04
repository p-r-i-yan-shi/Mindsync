import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class JournalData extends ChangeNotifier {
  final List<JournalEntry> _allEntries;

  List<JournalEntry> get entries => List<JournalEntry>.unmodifiable(
        _allEntries.where((JournalEntry e) => !e.isDeleted).toList()
          ..sort((JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp)),
      );

  List<JournalEntry> get deletedEntries => List<JournalEntry>.unmodifiable(
        _allEntries.where((JournalEntry e) => e.isDeleted).toList()
          ..sort((JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp)),
      );

  JournalData()
      : _allEntries = <JournalEntry>[
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '1',
            title: 'Morning Reflections',
            content: 'Woke up feeling refreshed after a good night\'s sleep. The sun was shining brightly, and I felt a sense of peace.',
            mood: Mood.happy,
            timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
            isFavorite: true,
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '2',
            title: 'Project Deadline Stress',
            content: 'Feeling the pressure with the project deadline approaching. Lots to do, but I\'m trying to stay focused.',
            mood: Mood.neutral,
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '3',
            title: 'Great Workout',
            content: 'Had an amazing workout session today! Feeling strong and energized.',
            mood: Mood.excited,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isFavorite: true,
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '4',
            title: 'Quiet Evening',
            content: 'A calm and quiet evening at home, reading a book. A good way to unwind.',
            mood: Mood.calm,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '5',
            title: 'Frustrating Bug',
            content: 'Spent hours debugging a tricky issue. Feeling a bit angry, but learned a lot.',
            mood: Mood.angry,
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '6',
            title: 'Rainy Day Blues',
            content: 'The weather is gloomy, and it\'s affecting my mood. Just feeling a bit down today.',
            mood: Mood.sad,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ] {
    _allEntries.sort((JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp));
  }

  void addEntry(JournalEntry entry) {
    _allEntries.add(entry);
    _allEntries.sort((JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  void updateEntry(JournalEntry updatedEntry) {
    final int index = _allEntries.indexWhere((JournalEntry entry) => entry.id == updatedEntry.id);
    if (index != -1) {
      _allEntries[index] = updatedEntry;
      _allEntries.sort((JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp));
      notifyListeners();
    }
  }

  void softDeleteEntry(String id) {
    final int index = _allEntries.indexWhere((JournalEntry entry) => entry.id == id);
    if (index != -1) {
      _allEntries[index] = _allEntries[index].copyWith(isDeleted: true);
      notifyListeners();
    }
  }

  void restoreEntry(String id) {
    final int index = _allEntries.indexWhere((JournalEntry entry) => entry.id == id);
    if (index != -1) {
      _allEntries[index] = _allEntries[index].copyWith(isDeleted: false);
      notifyListeners();
    }
  }

  void permanentlyDeleteEntry(String id) {
    _allEntries.removeWhere((JournalEntry entry) => entry.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final int index = _allEntries.indexWhere((JournalEntry entry) => entry.id == id);
    if (index != -1) {
      _allEntries[index].isFavorite = !_allEntries[index].isFavorite;
      notifyListeners();
    }
  }
} 