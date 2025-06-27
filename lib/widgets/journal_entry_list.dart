import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import 'journal_entry_card.dart';
import '../screens/journal_entry_screen.dart';

class JournalEntryList extends StatelessWidget {
  final List<JournalEntry> entries;
  final void Function(JournalEntry entry) onEdit;
  final void Function(String id) onDelete;
  final void Function(String id) onToggleFavorite;

  const JournalEntryList({
    super.key,
    required this.entries,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.article_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No entries yet.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a new one!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        final JournalEntry entry = entries[index];
        return JournalEntryCard(
          entry: entry,
          onEdit: () => onEdit(entry),
          onDelete: () => onDelete(entry.id),
          onToggleFavorite: () => onToggleFavorite(entry.id),
        );
      },
    );
  }
} 