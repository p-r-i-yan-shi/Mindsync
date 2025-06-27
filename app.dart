import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Keep this for Timer/Future use

// DATA MODEL
class JournalEntry {
  final String id;
  String title;
  String content;
  Mood mood;
  DateTime timestamp;
  bool isFavorite;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.timestamp,
    this.isFavorite = false,
  });

  // Factory constructor to create a JournalEntry from a map (for persistence or initial data)
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      mood: Mood.values.firstWhere(
        (Mood e) => e.toString() == 'Mood.${map['mood']}',
      ),
      timestamp: DateTime.parse(map['timestamp'] as String),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  // Convert JournalEntry to a map (for persistence)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'mood': mood.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}

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

class JournalData extends ChangeNotifier {
  List<JournalEntry> _entries;

  List<JournalEntry> get entries => List<JournalEntry>.unmodifiable(_entries);

  // Initial data for demonstration
  JournalData()
      : _entries = <JournalEntry>[
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '1',
            title: 'Morning Reflections',
            content:
                'Woke up feeling refreshed after a good night\'s sleep. The sun was shining brightly, and I felt a sense of peace.',
            mood: Mood.happy,
            timestamp:
                DateTime.now().subtract(const Duration(days: 2, hours: 3)),
            isFavorite: true,
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '2',
            title: 'Project Deadline Stress',
            content:
                'Feeling the pressure with the project deadline approaching. Lots to do, but I\'m trying to stay focused.',
            mood: Mood.neutral,
            timestamp: DateTime.now().subtract(
              const Duration(days: 1, hours: 10),
            ),
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '3',
            title: 'Great Workout',
            content:
                'Had an amazing workout session today! Feeling strong and energized.',
            mood: Mood.excited,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isFavorite: true,
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '4',
            title: 'Quiet Evening',
            content:
                'A calm and quiet evening at home, reading a book. A good way to unwind.',
            mood: Mood.calm,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '5',
            title: 'Frustrating Bug',
            content:
                'Spent hours debugging a tricky issue. Feeling a bit angry, but learned a lot.',
            mood: Mood.angry,
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
          ),
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '6',
            title: 'Rainy Day Blues',
            content:
                'The weather is gloomy, and it\'s affecting my mood. Just feeling a bit down today.',
            mood: Mood.sad,
            timestamp:
                DateTime.now().subtract(const Duration(days: 0, hours: 2)),
          ),
        ] {
    // Sort entries by timestamp in descending order (most recent first)
    _entries.sort(
      (JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp),
    );
  }

  void addEntry(JournalEntry entry) {
    _entries.add(entry);
    _entries.sort(
      (JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp),
    ); // Keep sorted
    notifyListeners();
  }

  void updateEntry(JournalEntry updatedEntry) {
    final int index = _entries.indexWhere(
      (JournalEntry entry) => entry.id == updatedEntry.id,
    );
    if (index != -1) {
      _entries[index] = updatedEntry;
      _entries.sort(
        (JournalEntry a, JournalEntry b) => b.timestamp.compareTo(a.timestamp),
      ); // Keep sorted
      notifyListeners();
    }
  }

  void deleteEntry(String id) {
    _entries.removeWhere((JournalEntry entry) => entry.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final int index = _entries.indexWhere(
      (JournalEntry entry) => entry.id == id,
    );
    if (index != -1) {
      _entries[index].isFavorite = !_entries[index].isFavorite;
      notifyListeners();
    }
  }
}

// WIDGETS
class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    entry.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(4.0),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    entry.isFavorite ? Icons.star : Icons.star_border,
                    color: entry.isFavorite
                        ? Colors.amber
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onToggleFavorite,
                ),
                IconButton(
                  padding: const EdgeInsets.all(4.0),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: onEdit,
                ),
                IconButton(
                  padding: const EdgeInsets.all(4.0),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Icon(
                  entry.mood.icon,
                  color: entry.mood.getColor(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  entry.mood.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: entry.mood.getColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                Text(
                  '${entry.timestamp.day}/${entry.timestamp.month}/${entry.timestamp.year} ${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              entry.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

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

class JournalEntryScreen extends StatefulWidget {
  final JournalEntry? entry; // Null if adding new, non-null if editing
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
    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a mood.')));
        return;
      }

      final String newTitle = _titleController.text;
      final String newContent = _contentController.text;

      if (widget.entry == null) {
        // Add new entry
        final JournalEntry newEntry = JournalEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
          title: newTitle,
          content: newContent,
          mood: _selectedMood!,
          timestamp: _selectedTimestamp,
          isFavorite: false,
        );
        Provider.of<JournalData>(context, listen: false).addEntry(newEntry);
      } else {
        // Update existing entry
        final JournalEntry updatedEntry = JournalEntry(
          id: widget.entry!.id,
          title: newTitle,
          content: newContent,
          mood: _selectedMood!,
          timestamp: _selectedTimestamp,
          isFavorite: widget.entry!.isFavorite, // Preserve favorite status
        );
        Provider.of<JournalData>(
          context,
          listen: false,
        ).updateEntry(updatedEntry);
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedTimestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null &&
        pickedDate.toLocal() != _selectedTimestamp.toLocal()) {
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
    if (pickedTime != null &&
        pickedTime != TimeOfDay.fromDateTime(_selectedTimestamp)) {
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
        title: Text(
          widget.entry == null ? 'New Journal Entry' : 'Edit Journal Entry',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'A short summary of your entry',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'What\'s on your mind?',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Content cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              MoodPicker(
                selectedMood: _selectedMood,
                onMoodSelected: (Mood? mood) {
                  setState(() {
                    _selectedMood = mood;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Date and Time',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Text(
                          '${_selectedTimestamp.day}/${_selectedTimestamp.month}/${_selectedTimestamp.year}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        child: Text(
                          '${_selectedTimestamp.hour}:${_selectedTimestamp.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.entry == null ? 'Save Entry' : 'Update Entry',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JournalEntryList extends StatelessWidget {
  final List<JournalEntry> entries;

  const JournalEntryList({super.key, required this.entries});

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
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withAlpha(128),
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
          onEdit: () {
            Navigator.of(context).push(
              MaterialPageRoute<JournalEntryScreen>(
                builder: (BuildContext context) =>
                    JournalEntryScreen(entry: entry),
              ),
            );
          },
          onDelete: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: Text(
                    'Are you sure you want to delete "${entry.title}"?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        Provider.of<JournalData>(
                          context,
                          listen: false,
                        ).deleteEntry(entry.id);
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Entry deleted.')),
                        );
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onToggleFavorite: () {
            Provider.of<JournalData>(
              context,
              listen: false,
            ).toggleFavorite(entry.id);
          },
        );
      },
    );
  }
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MindSync Journal',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
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
      body: Consumer<JournalData>(
        builder:
            (BuildContext context, JournalData journalData, Widget? child) {
          final List<JournalEntry> allEntries = journalData.entries;
          final List<JournalEntry> favoriteEntries = journalData.entries
              .where((JournalEntry e) => e.isFavorite)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: <Widget>[
              JournalEntryList(entries: allEntries),
              JournalEntryList(entries: favoriteEntries),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<JournalEntryScreen>(
              builder: (BuildContext context) => const JournalEntryScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Placeholder for the LoginScreen to make navigation functional
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logging in...')));
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login to MindSync',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Image.network(
                  'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue your journey.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        fillColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        fillColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Forgot password functionality not implemented.',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sign up functionality not implemented.',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New DATA MODEL for AI Chat messages
class ChatMessage {
  final String text;
  final bool isUser; // true for user, false for AI
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// New Widget for AI Assistant Screen
class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[
    ChatMessage(
      text:
          'Hello! How can I help you reflect on your day or understand your journal entries?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final String userMessageText = _textController.text.trim();
    if (userMessageText.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        ChatMessage(
          text: userMessageText,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
      _textController.clear();
    });

    _scrollToBottom();

    // Simulate AI response
    await Future<void>.delayed(const Duration(seconds: 2));

    String aiResponse;
    if (userMessageText.toLowerCase().contains('how are you')) {
      aiResponse =
          'I am an AI, so I don\'t have feelings, but I\'m ready to assist you!';
    } else if (userMessageText.toLowerCase().contains('journal')) {
      aiResponse =
          'What about your journal would you like to discuss? I can help you analyze patterns or suggest prompts.';
    } else if (userMessageText.toLowerCase().contains('mood')) {
      aiResponse =
          'Understanding your mood is important. Would you like to explore why you\'re feeling a certain way?';
    } else if (userMessageText.toLowerCase().contains('hello') ||
        userMessageText.toLowerCase().contains('hi')) {
      aiResponse = 'Hi there! How can I assist you today?';
    } else {
      aiResponse =
          'That\'s an interesting thought. Can you tell me more about what you\'re trying to achieve?';
    }

    setState(() {
      _messages.add(
        ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()),
      );
      _isLoading = false;
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Talk to NUMA',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final ChatMessage message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: message.isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.text,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: message.isUser
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: message.isUser
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                        .withOpacity(0.7)
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                    ),
                    onSubmitted: (String value) => _sendMessage(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                const SizedBox(width: 8),
                _isLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : FloatingActionButton.small(
                        onPressed: _sendMessage,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        elevation: 4,
                        child: const Icon(Icons.send),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// New Widget for Wellbeing Graph Screen
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
    final int maxCount = moodCounts.values.isEmpty
        ? 1
        : moodCounts.values.reduce((int a, int b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Wellbeing Graph',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: totalEntries == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.bar_chart,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withAlpha(128),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No entries to graph yet.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add journal entries to see your mood trends!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Mood Distribution (${totalEntries} entries)',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: Mood.values.map<Widget>((Mood mood) {
                        final int count = moodCounts[mood] ?? 0;
                        final double percentage = totalEntries > 0
                            ? (count / totalEntries)
                            : 0.0;
                        final double barWidth =
                            maxCount > 0 ? (count / maxCount) : 0.0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width:
                                    100, // Fixed width for mood label and icon
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      mood.icon,
                                      color: mood.getColor(context),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        mood.displayName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (
                                    BuildContext context,
                                    BoxConstraints constraints,
                                  ) {
                                    return Stack(
                                      children: <Widget>[
                                        Container(
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: barWidth,
                                          child: Container(
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: mood
                                                  .getColor(context)
                                                  .withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                              ),
                                              child: Text(
                                                '${count} (${(percentage * 100).toStringAsFixed(1)}%)',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                              ),
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
            ),
    );
  }
}

// New Widget for Profile and Settings Screen
class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    final bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle(context, 'Profile Information'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                      ), // Placeholder image
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edit profile functionality not implemented.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'App Settings'),
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    secondary: const Icon(Icons.dark_mode),
                    value: isDarkMode,
                    onChanged: (bool value) {
                      themeNotifier.toggleTheme();
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveThumbColor: Theme.of(context).colorScheme.outline,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About App'),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MindSync Journal',
                        applicationVersion: '1.0.0',
                        applicationLegalese:
                            '© 2023 MindSync. All rights reserved.',
                        children: <Widget>[
                          Text(
                            'A personal journal and AI assistant for reflection and wellbeing.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

// New Home Screen with Bottom Navigation Bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const JournalScreen(),
      const AIAssistantScreen(),
      const WellbeingGraphScreen(),
      const ProfileSettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_outlined),
              activeIcon: Icon(Icons.psychology),
              label: 'NUMA AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Wellbeing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          onTap: _onItemTapped,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}

// New Get Started Screen
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Image.network(
                  'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'MindSync Journal',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your Journey to a Mindful Life Starts Here.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  icon: const Icon(Icons.login),
                  label: Text(
                    'Login',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign up functionality not implemented.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(
                    'Get Started (Sign Up)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Theme Notifier for Dark Mode
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}

// Helper function to build theme data
ThemeData _buildTheme(Brightness brightness, ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    brightness: brightness,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
      ),
      prefixIconColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.focused)) {
          return colorScheme.primary;
        }
        if (states.contains(WidgetState.error)) {
          return colorScheme.error;
        }
        return colorScheme.onSurfaceVariant;
      }),
    ),
    cardTheme: CardThemeData( // Corrected from CardTheme to CardThemeData
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <Widget>[ // Corrected from <SingleChildWidget> to <Widget>
        ChangeNotifierProvider<JournalData>(
          create: (BuildContext context) => JournalData(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (BuildContext context) => ThemeNotifier(ThemeMode.system),
        ),
      ],
      builder: (BuildContext context, Widget? child) {
        final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

        final ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        );
        final ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

        final ThemeData lightTheme = _buildTheme(
          Brightness.light,
          lightColorScheme,
        );
        final ThemeData darkTheme = _buildTheme(
          Brightness.dark,
          darkColorScheme,
        );

        return MaterialApp(
          title: 'MindSync Journal',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
          initialRoute: '/getStarted', // New initial route
          routes: <String, WidgetBuilder>{
            '/getStarted': (BuildContext context) =>
                const GetStartedScreen(), // New route
            '/login': (BuildContext context) => const LoginScreen(),
            '/home': (BuildContext context) => const HomeScreen(),
          },
        );
      },
    );
  }
}

void main() {
  runApp(const MyApp());
}