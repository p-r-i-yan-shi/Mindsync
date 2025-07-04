import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/journal_entry.dart';
import '../providers/journal_data.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _journalController = TextEditingController();
  Mood? _selectedMood;

  // Mood row: emoji, color, and icon order to match reference
  final List<_MoodIcon> moodIcons = const [
    _MoodIcon(icon: Icons.sentiment_neutral, color: Color(0xFFED6A5A)), // Red
    _MoodIcon(icon: Icons.sentiment_satisfied, color: Color(0xFFFFC145)), // Yellow
    _MoodIcon(icon: Icons.sentiment_very_satisfied, color: Color(0xFF4ECDC4)), // Green
    _MoodIcon(icon: Icons.sentiment_satisfied_alt, color: Color(0xFF5A8DEE)), // Blue
    _MoodIcon(icon: Icons.emoji_emotions, color: Color(0xFF7B61FF)), // Purple
  ];

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_journalController.text.trim().isEmpty) return;
    Provider.of<JournalData>(context, listen: false).addEntry(
      JournalEntry(
        id: DateTime.now().toString(),
        title: "Today's Journal",
        content: _journalController.text.trim(),
        mood: _selectedMood ?? Mood.neutral,
        timestamp: DateTime.now(),
        isFavorite: false,
        isDeleted: false,
      ),
    );
    _journalController.clear();
    setState(() {
      _selectedMood = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final journalData = Provider.of<JournalData>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Greeting Bar
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF7B61FF),
                  child: Text(
                    't',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, there!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'How are you feeling today?',
                        style: GoogleFonts.poppins(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.settings, color: colorScheme.onSurfaceVariant),
                    onPressed: () {},
                    tooltip: 'Settings',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Quick Mood Check
          Text(
            'Quick Mood Check',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(moodIcons.length, (i) => Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMood = Mood.values[i]),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: moodIcons[i].color,
                    child: Icon(
                      moodIcons[i].icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              )),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Tap',
                    style: GoogleFonts.poppins(
                      color: Color(0xFFB6B8D6),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'to log',
                    style: GoogleFonts.poppins(
                      color: Color(0xFFB6B8D6),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          // Today's Journal Card
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colorScheme.surfaceVariant, width: 1.2),
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Today's Journal",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B61FF), Color(0xFF5A4FFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: const Icon(Icons.mic, color: Colors.white, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: TextField(
                    controller: _journalController,
                    minLines: 3,
                    maxLines: 5,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Write your thoughts... ',
                      hintStyle: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 130,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: _saveEntry,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B61FF), Color(0xFF5A4FFF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Save Entry',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Recent Entries
          Text(
            'Recent Entries',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (journalData.entries.isEmpty)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colorScheme.surfaceVariant, width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 38),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 38, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 10),
                  Text(
                    'No journal entries yet',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start by writing your first entry above',
                    style: GoogleFonts.poppins(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          // TODO: Add list of recent entries if not empty
        ],
      ),
    );
  }
}

class _MoodIcon {
  final IconData icon;
  final Color color;
  const _MoodIcon({required this.icon, required this.color});
} 