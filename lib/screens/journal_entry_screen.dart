import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../widgets/mood_picker.dart';
import 'package:provider/provider.dart';
import '../providers/journal_data.dart';

class JournalEntryScreen extends StatefulWidget {
  final JournalEntry? entry;
  const JournalEntryScreen({super.key, this.entry});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Mood? _selectedMood;
  late DateTime _selectedTimestamp;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _selectedMood = widget.entry?.mood;
    _selectedTimestamp = widget.entry?.timestamp ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedMood == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a mood.')));
        return;
      }
      final String newTitle = _titleController.text;
      final String newContent = _contentController.text;
      if (widget.entry == null) {
        final JournalEntry newEntry = JournalEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: newTitle,
          content: newContent,
          mood: _selectedMood!,
          timestamp: _selectedTimestamp,
          isFavorite: false,
          isDeleted: false,
        );
        Provider.of<JournalData>(context, listen: false).addEntry(newEntry);
      } else {
        final JournalEntry updatedEntry = widget.entry!.copyWith(
          title: newTitle,
          content: newContent,
          mood: _selectedMood!,
          timestamp: _selectedTimestamp,
        );
        Provider.of<JournalData>(context, listen: false).updateEntry(updatedEntry);
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedTimestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate != null && pickedDate.toLocal() != _selectedTimestamp.toLocal()) {
      setState(() {
        _selectedTimestamp = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedTimestamp.hour,
          _selectedTimestamp.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTimestamp),
    );
    if (pickedTime != null && pickedTime != TimeOfDay.fromDateTime(_selectedTimestamp)) {
      setState(() {
        _selectedTimestamp = DateTime(
          _selectedTimestamp.year,
          _selectedTimestamp.month,
          _selectedTimestamp.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (String? value) => value == null || value.isEmpty ? 'Please enter a title.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 6,
                validator: (String? value) => value == null || value.isEmpty ? 'Please enter some content.' : null,
              ),
              const SizedBox(height: 16),
              MoodPicker(selectedMood: _selectedMood, onMoodSelected: (m) => setState(() => _selectedMood = m)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveEntry,
                  icon: const Icon(Icons.save),
                  label: Text(widget.entry == null ? 'Save Entry' : 'Update Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 