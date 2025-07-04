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
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: Mood.values.map((Mood mood) {
            final bool isSelected = selectedMood == mood;
            return ChoiceChip(
              label: Text(mood.displayName),
              avatar: Icon(
                mood.icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : mood.getColor(context),
              ),
              selected: isSelected,
              selectedColor: mood.getColor(context),
              onSelected: (_) => onMoodSelected(mood),
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            );
          }).toList(),
        ),
      ],
    );
  }
} 