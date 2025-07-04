import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../providers/journal_data.dart';

class WellbeingGraphScreen extends StatelessWidget {
  const WellbeingGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JournalData journalData = Provider.of<JournalData>(context);
    final Map<Mood, int> moodCounts = <Mood, int>{};
    for (final Mood mood in Mood.values) {
      moodCounts[mood] = 0;
    }
    for (final JournalEntry entry in journalData.entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }
    final int totalEntries = journalData.entries.length;
    final int maxCount = moodCounts.values.isEmpty ? 1 : moodCounts.values.reduce((int a, int b) => a > b ? a : b);
    return totalEntries == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.bar_chart, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(128)),
                const SizedBox(height: 16),
                Text('No entries to graph yet.', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text('Add journal entries to see your mood trends!', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Mood Distribution ($totalEntries entries)', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: Mood.values.map<Widget>((Mood mood) {
                      final int count = moodCounts[mood] ?? 0;
                      final double percentage = totalEntries > 0 ? (count / totalEntries) : 0.0;
                      final double barWidth = maxCount > 0 ? (count / maxCount) : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                              child: Row(
                                children: <Widget>[
                                  Icon(mood.icon, color: mood.getColor(context)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(mood.displayName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  return Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: barWidth,
                                        child: Container(
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: mood.getColor(context).withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text('$count (${(percentage * 100).toStringAsFixed(1)}%)', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
  }
} 