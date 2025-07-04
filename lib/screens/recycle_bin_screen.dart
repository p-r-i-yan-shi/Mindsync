import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../providers/journal_data.dart';
import '../widgets/journal_entry_card.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle Bin', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<JournalData>(
        builder: (BuildContext context, JournalData journalData, Widget? child) {
          final List<JournalEntry> deletedEntries = journalData.deletedEntries;
          return deletedEntries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete_sweep_outlined, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(128)),
                      const SizedBox(height: 16),
                      Text('Recycle bin is empty.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      Text('Deleted entries will appear here.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: deletedEntries.length,
                  itemBuilder: (BuildContext context, int index) {
                    final JournalEntry entry = deletedEntries[index];
                    return DeletedJournalEntryCard(
                      entry: entry,
                      onRestore: () {
                        Provider.of<JournalData>(context, listen: false).restoreEntry(entry.id);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry restored.')));
                      },
                      onPermanentDelete: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Confirm Permanent Delete'),
                              content: Text('Are you sure you want to permanently delete "${entry.title}"? This cannot be undone.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                  child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                                  onPressed: () {
                                    Provider.of<JournalData>(context, listen: false).permanentlyDeleteEntry(entry.id);
                                    Navigator.of(dialogContext).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry permanently deleted.')));
                                  },
                                  child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.onError)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
} 