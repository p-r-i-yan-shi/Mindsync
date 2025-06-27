import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class MoodPicker extends StatelessWidget {
  final Mood? selectedMood;
  final ValueChanged<Mood?> onMoodSelected;

  const MoodPicker({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'How are you feeling?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: Mood.values.map<Widget>((Mood mood) {
            final bool isSelected = selectedMood == mood;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    mood.icon,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : mood.getColor(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    mood.displayName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.primary,
              onSelected: (bool selected) {
                onMoodSelected(selected ? mood : null);
              },
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            );
          }).toList(),
        ),
      ],
    );
  }
} 