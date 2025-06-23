import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_dashboard_screen.dart';
import 'quote_suggestions_screen.dart';
import 'ai_chat_screen.dart';
import 'mood_tracker_screen.dart';
import 'profile_achievements_screen.dart';
import 'settings_screen.dart';

final bottomNavProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavProvider);
    final screens = [
      const HomeDashboardScreen(),
      const QuoteSuggestionsScreen(),
      const AiChatScreen(),
      const MoodTrackerScreen(),
      // Profile and settings can be merged or separated as needed
      const ProfileAchievementsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => ref.read(bottomNavProvider.notifier).state = i,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_rounded), label: 'Suggestions'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Numa'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
} 