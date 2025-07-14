import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ai_assistant_screen.dart';
import 'mood_tracking_screen.dart';
import 'profile_settings_screen.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
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
                // Header
                Text(
                  'AI Suggestions',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Personalized recommendations for your wellness',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Quote Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF313A5A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: const Color(0xFF7B61FF),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"The best way to take care of the future is to take care of the present moment."',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '- Thich Nhat Hanh',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // For You Today Section
                Text(
                  'For You Today',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Calming Sounds Card
                _suggestionCard(
                  title: 'Calming Sounds',
                  subtitle: '5-minute nature meditation',
                  icon: Icons.headphones,
                  iconColor: const Color(0xFF4ADE80),
                  buttonText: '',
                  hasPlayButton: true,
                  onTap: () {},
                ),
                
                const SizedBox(height: 16),
                
                // Take a Walk Card
                _suggestionCard(
                  title: 'Take a Walk',
                  subtitle: 'Fresh air boosts mood',
                  icon: Icons.directions_walk,
                  iconColor: const Color(0xFF22C55E),
                  buttonText: 'Mark as Done',
                  buttonColor: const Color(0xFF22C55E),
                  onTap: () {},
                ),
                
                const SizedBox(height: 16),
                
                // Mindfulness Exercise Card
                _suggestionCard(
                  title: 'Mindfulness Exercise',
                  subtitle: '3-minute breathing space',
                  icon: Icons.self_improvement,
                  iconColor: const Color(0xFF7B61FF),
                  buttonText: 'Start Exercise',
                  buttonColor: const Color(0xFF7B61FF),
                  onTap: () {},
                ),
                
                const SizedBox(height: 16),
                
                // Hydration Reminder Card
                _suggestionCard(
                  title: 'Hydration Reminder',
                  subtitle: 'Stay hydrated for better mood',
                  icon: Icons.local_drink,
                  iconColor: const Color(0xFF8B5CF6),
                  buttonText: 'Had Water',
                  buttonColor: const Color(0xFF8B5CF6),
                  onTap: () {},
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _customBottomNavBar(context, 1),
    );
  }

  Widget _suggestionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String buttonText,
    Color? buttonColor,
    bool hasPlayButton = false,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF232A4D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF313A5A), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Icon with image background for calming sounds
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasPlayButton)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B61FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: onTap,
                  ),
                ),
            ],
          ),
          if (buttonText.isNotEmpty && !hasPlayButton) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
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
          _navBarItem(Icons.help_outline, 'Suggestions', selectedIndex == 1, () {}),
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
}

