import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../widgets/journal_entry_list.dart';
import 'journal_entry_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Demo data
    _entries = [
      JournalEntry(
        id: '1',
        title: 'Welcome to MindSync!',
        content: 'This is your first journal entry. Start writing your thoughts!',
        mood: Mood.happy,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isFavorite: true,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addOrUpdateEntry(JournalEntry entry) {
    setState(() {
      final idx = _entries.indexWhere((e) => e.id == entry.id);
      if (idx == -1) {
        _entries.insert(0, entry);
      } else {
        _entries[idx] = entry;
      }
    });
  }

  void _deleteEntry(String id) {
    setState(() {
      _entries.removeWhere((e) => e.id == id);
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      final idx = _entries.indexWhere((e) => e.id == id);
      if (idx != -1) {
        _entries[idx].isFavorite = !_entries[idx].isFavorite;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allEntries = _entries;
    final favoriteEntries = _entries.where((e) => e.isFavorite).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('MindSync Journal', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'All Entries', icon: Icon(Icons.book)),
            Tab(text: 'Favorites', icon: Icon(Icons.star)),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          JournalEntryList(
            entries: allEntries,
            onEdit: (entry) async {
              final result = await Navigator.of(context).push<JournalEntry>(
                MaterialPageRoute(
                  builder: (context) => JournalEntryScreen(entry: entry),
                ),
              );
              if (result != null) _addOrUpdateEntry(result);
            },
            onDelete: (id) => _deleteEntry(id),
            onToggleFavorite: (id) => _toggleFavorite(id),
          ),
          JournalEntryList(
            entries: favoriteEntries,
            onEdit: (entry) async {
              final result = await Navigator.of(context).push<JournalEntry>(
                MaterialPageRoute(
                  builder: (context) => JournalEntryScreen(entry: entry),
                ),
              );
              if (result != null) _addOrUpdateEntry(result);
            },
            onDelete: (id) => _deleteEntry(id),
            onToggleFavorite: (id) => _toggleFavorite(id),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<JournalEntry>(
            MaterialPageRoute(
              builder: (context) => const JournalEntryScreen(),
            ),
          );
          if (result != null) _addOrUpdateEntry(result);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// JournalEntryList will be moved to widgets/journal_entry_list.dart 