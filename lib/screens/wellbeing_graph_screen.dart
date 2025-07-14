import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/journal_entry.dart';
import '../providers/journal_data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class WellbeingGraphScreen extends StatefulWidget {
  const WellbeingGraphScreen({super.key});

  @override
  State<WellbeingGraphScreen> createState() => _WellbeingGraphScreenState();
}

class _WellbeingGraphScreenState extends State<WellbeingGraphScreen> {
  Mood? _selectedMood;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _logMood(Mood mood, JournalData journalData) {
    setState(() {
      _selectedMood = mood;
    });
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Mood Log',
      content: '',
      mood: mood,
      timestamp: DateTime.now(),
    );
    journalData.addEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood logged: ${mood.displayName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journalData = Provider.of<JournalData>(context);
    final entries = journalData.entries;
    final selectedEntries = _selectedDay == null
        ? entries
        : entries.where((e) =>
            e.timestamp.year == _selectedDay!.year &&
            e.timestamp.month == _selectedDay!.month &&
            e.timestamp.day == _selectedDay!.day).toList();
    final moodCounts = <Mood, int>{};
    for (final mood in Mood.values) {
      moodCounts[mood] = 0;
    }
    for (final entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }
    final int totalEntries = entries.length;
    final int streak = _calculateStreak(entries);
    return Scaffold(
      backgroundColor: const Color(0xFF232A4D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Mood Tracker',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track and understand your emotional patterns',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                // Calendar Widget
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF313A5A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF7B61FF),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      defaultTextStyle: const TextStyle(color: Colors.white),
                    ),
                    headerStyle: HeaderStyle(
                      titleTextStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      formatButtonVisible: false,
                      leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
                      rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
                      decoration: const BoxDecoration(color: Color(0xFF232A4D)),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                      weekendStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Mood icons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _moodIcon(Mood.sad, '😔', false, journalData),
                    _moodIcon(Mood.neutral, '😐', false, journalData),
                    _moodIcon(Mood.happy, '🙂', false, journalData),
                    _moodIcon(Mood.calm, '😃', false, journalData),
                    _moodIcon(Mood.excited, '🤩', false, journalData),
                  ],
                ),
                const SizedBox(height: 12),
                if (_selectedMood != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _selectedMood!.displayName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                // Weekly Overview Card
                _weeklyOverviewCard(entries),
                const SizedBox(height: 20),
                // Insights Card
                _insightsCard(moodCounts, streak, totalEntries),
                const SizedBox(height: 20),
                // Timeline Widget (real data)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF313A5A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood Timeline',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (selectedEntries.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text('No entries for this day.', style: TextStyle(color: Colors.white70)),
                        )
                      else
                        ...selectedEntries.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final e = entry.value;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 350 + idx * 50),
                            curve: Curves.easeInOut,
                            child: TimelineTile(
                              nodeAlign: TimelineNodeAlign.start,
                              contents: Padding(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${e.mood.emoji} ${e.mood.displayName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                    if (e.title.isNotEmpty) Text(e.title, style: TextStyle(color: Colors.white70)),
                                    if (e.content.isNotEmpty) Text(e.content, style: TextStyle(color: Colors.white54)),
                                    Text('${e.timestamp.hour.toString().padLeft(2, '0')}:${e.timestamp.minute.toString().padLeft(2, '0')}', style: TextStyle(color: Colors.white38, fontSize: 12)),
                                  ],
                                ),
                              ),
                              node: TimelineNode(
                                indicator: DotIndicator(color: e.mood.getColor(context)),
                                endConnector: idx < selectedEntries.length - 1 ? SolidLineConnector(color: Colors.white24) : null,
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Recent Entries Card
                _recentEntriesCard(entries),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moodIcon(Mood mood, String emoji, bool selected, JournalData journalData) {
    final bool isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => _logMood(mood, journalData),
      child: Container(
        width: isSelected ? 60 : 48,
        height: isSelected ? 60 : 48,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: isSelected ? 32 : 28),
          ),
        ),
      ),
    );
  }

  Widget _weeklyOverviewCard(List<JournalEntry> entries) {
    // Show a bar for each day of the week, height based on number of entries
    final now = DateTime.now();
    final weekDays = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    final moodPerDay = <int>[];
    for (final day in weekDays) {
      final count = entries.where((e) =>
        e.timestamp.year == day.year &&
        e.timestamp.month == day.month &&
        e.timestamp.day == day.day).length;
      moodPerDay.add(count);
    }
    final maxCount = moodPerDay.isEmpty ? 1 : (moodPerDay.reduce((a, b) => a > b ? a : b) == 0 ? 1 : moodPerDay.reduce((a, b) => a > b ? a : b));
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF313A5A),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Overview',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF232A4D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final barHeight = 18 + (moodPerDay[index] / maxCount) * 32;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 18,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B61FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'][index],
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightsCard(Map<Mood, int> moodCounts, int streak, int totalEntries) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF232A4D),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insights',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.arrow_upward, color: Color(0xFF4ADE80)),
              const SizedBox(width: 12),
              Text(
                totalEntries > 0 ? 'Keep it up! Logging daily helps.' : 'Start tracking to see insights',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFF60A5FA)),
              const SizedBox(width: 12),
              Text(
                'Current streak: $streak days',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.list_alt, color: Color(0xFF8B5CF6)),
              const SizedBox(width: 12),
              Text(
                'Total entries: $totalEntries',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recentEntriesCard(List<JournalEntry> entries) {
    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF232A4D),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, color: Color(0xFFB6B8D6), size: 32),
            const SizedBox(height: 8),
            Text(
              'No mood entries yet',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start by selecting your mood above',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: entries.take(3).map((entry) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF313A5A),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(entry.mood.icon, color: entry.mood.getColor(context), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    entry.mood.displayName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entry.content.isEmpty ? '(Mood only)' : entry.content,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  int _calculateStreak(List<JournalEntry> entries) {
    if (entries.isEmpty) return 0;
    entries = List.from(entries)..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    int streak = 1;
    DateTime last = entries.first.timestamp;
    for (int i = 1; i < entries.length; i++) {
      final diff = last.difference(entries[i].timestamp).inDays;
      if (diff == 1) {
        streak++;
        last = entries[i].timestamp;
      } else if (diff > 1) {
        break;
      }
    }
    return streak;
  }
} 