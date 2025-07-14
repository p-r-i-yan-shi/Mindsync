import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'suggestions_screen.dart';
import 'ai_assistant_screen.dart';
import 'mood_tracking_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

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
                const SizedBox(height: 32),
                Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your wellness journey & settings',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                // Profile Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B61FF), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          't',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wellness Explorer',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'test@example.com',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Member since Recently',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statCard('0', 'Journal Entries'),
                    _statCard('0', 'Day Streak'),
                  ],
                ),
                const SizedBox(height: 24),
                // Achievements
                Text(
                  'Achievements',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _achievementCard(Icons.star_border, 'First Entry'),
                    _achievementCard(Icons.calendar_today, '7 Day Streak'),
                    _achievementCard(Icons.emoji_events_outlined, 'Mood Master'),
                  ],
                ),
                const SizedBox(height: 24),
                // Settings
                Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _settingsToggle('Dark Mode', true),
                const SizedBox(height: 8),
                _settingsToggle('Notifications', true),
                const SizedBox(height: 8),
                _settingsToggle('Email Reminders', false),
                const SizedBox(height: 32),
                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0xFFEF4444), width: 2),
                      ),
                    ),
                    child: Text(
                      'Sign Out',
                      style: GoogleFonts.poppins(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _customBottomNavBar(context, 4),
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
          _navBarItem(Icons.bar_chart_outlined, 'Mood', selectedIndex == 3, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
            );
          }),
          _navBarItem(Icons.person_outline, 'Profile', selectedIndex == 4, () {}),
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

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF313A5A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _achievementCard(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF313A5A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.5), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsToggle(String label, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF313A5A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) {},
            activeColor: const Color(0xFF7B61FF),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white24,
          ),
        ],
      ),
    );
  }
} 