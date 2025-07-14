import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'suggestions_screen.dart';
import 'ai_assistant_screen.dart';
import 'profile_settings_screen.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  String selectedMood = 'Happy';
  int currentStreak = 0;
  int totalEntries = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232A4D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Header with mood selection
                Text(
                  'Mood Tracker',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track and understand your emotional patterns',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                
                // How are you feeling section
                Text(
                  'How are you feeling?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Mood selection
                _moodSelectionRow(),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    selectedMood,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Weekly Overview Card
                _weeklyOverviewCard(),
                
                const SizedBox(height: 20),
                
                // Insights Card
                _insightsCard(),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _customBottomNavBar(context, 3),
    );
  }

  Widget _customBottomNavBar(BuildContext context, int selectedIndex) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF232A4D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navBarItem(Icons.home, 'Home', selectedIndex == 0, () {
            Navigator.of(context).pushReplacementNamed('/home');
          }),
          _navBarItem(Icons.help_outline, 'Suggestions', selectedIndex == 1, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SuggestionsScreen()),
            );
          }),
          _navBarItem(Icons.chat_bubble_outline, 'Chat', selectedIndex == 2, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AIAssistantScreen()),
            );
          }),
          _navBarItem(Icons.bar_chart_outlined, 'Mood', selectedIndex == 3, () {}),
          _navBarItem(Icons.person_outline, 'Profile', selectedIndex == 4, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _navBarItem(IconData icon, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFF7B61FF) : const Color(0xFFB6B8D6),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: selected ? const Color(0xFF7B61FF) : const Color(0xFFB6B8D6),
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _moodSelectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _moodButton('😔', 'Sad'),
        _moodButton('😐', 'Neutral'),
        _moodButton('😊', 'Happy'),
        _moodButton('😃', 'Excited'),
        _moodButton('🤩', 'Amazing'),
      ],
    );
  }

  Widget _moodButton(String emoji, String mood) {
    bool isSelected = selectedMood == mood;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7B61FF).withOpacity(0.3) : const Color(0xFF313A5A),
          borderRadius: BorderRadius.circular(28),
          border: isSelected ? Border.all(color: const Color(0xFF7B61FF), width: 2) : null,
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }

  Widget _weeklyOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF313A5A),
        borderRadius: BorderRadius.circular(16),
      ),
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
          // Chart placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF232A4D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _chartBar('Fri', 0.3),
                  _chartBar('Sat', 0.6),
                  _chartBar('Sun', 0.4),
                  _chartBar('Mon', 0.8),
                  _chartBar('Tue', 0.5),
                  _chartBar('Wed', 0.7),
                  _chartBar('Thu', 0.9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartBar(String day, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 16,
          height: 60 * height,
          decoration: BoxDecoration(
            color: const Color(0xFF7B61FF),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _insightsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF313A5A),
        borderRadius: BorderRadius.circular(16),
      ),
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
          _insightRow(Icons.trending_up, const Color(0xFF4ADE80), 'Start tracking to see insights'),
          const SizedBox(height: 12),
          _insightRow(Icons.calendar_today, const Color(0xFF3B82F6), 'Current streak: 0 days'),
          const SizedBox(height: 12),
          _insightRow(Icons.timeline, const Color(0xFF8B5CF6), 'Total entries: 0'),
        ],
      ),
    );
  }

  Widget _insightRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

