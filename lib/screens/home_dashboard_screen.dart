import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart'; // For AppColors
import 'package:my_flutter/screens/ai_chat_screen.dart';
import 'package:my_flutter/screens/journal_entry_screen.dart';
import 'package:my_flutter/screens/mood_tracker_screen.dart';
import 'package:my_flutter/screens/notifications_screen.dart';
import 'package:my_flutter/screens/profile_achievements_screen.dart';
import 'package:my_flutter/screens/quote_suggestions_screen.dart';
import 'package:my_flutter/screens/settings_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // 'Learn' - Navigates to Journal Entry as a placeholder for now
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JournalEntryScreen()),
        );
        break;
      case 1:
        // 'Practice' - Navigates to AI Chat
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AIChatScreen()),
        );
        break;
      case 2:
        // 'Notifications'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
        break;
      case 3:
        // 'Profile'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileAchievementsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primaryDark.withOpacity(0.8),
              AppColors.darkGrey,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGreeting(),
                          const SizedBox(height: 24),
                          _buildMoodSection(),
                          const SizedBox(height: 24),
                          _buildDashboardGrid(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'MindSync',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppColors.textColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, User!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'How are you feeling today?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.lightGrey,
                fontSize: 16,
              ),
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Mood',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodButton(Icons.sentiment_very_dissatisfied, 'Sad'),
              _buildMoodButton(Icons.sentiment_dissatisfied, 'Down'),
              _buildMoodButton(Icons.sentiment_neutral, 'Neutral'),
              _buildMoodButton(Icons.sentiment_satisfied, 'Good'),
              _buildMoodButton(Icons.sentiment_very_satisfied, 'Great'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.accentPurple, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.lightGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.1,
        children: [
          _buildDashboardCard(
            context,
            'Journal',
            Icons.edit_note,
            'Record your thoughts and feelings',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JournalEntryScreen()),
              );
            },
          ),
          _buildDashboardCard(
            context,
            'Talk to AI',
            Icons.chat_bubble_outline,
            'Get support and guidance',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIChatScreen()),
              );
            },
          ),
          _buildDashboardCard(
            context,
            'Mood Tracker',
            Icons.mood_outlined,
            'Track your emotional journey',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
              );
            },
          ),
          _buildDashboardCard(
            context,
            'Daily Quote',
            Icons.format_quote,
            'Get inspired daily',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuoteSuggestionsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: AppColors.accentPurple),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.lightGrey,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accentPurple,
        unselectedItemColor: AppColors.lightGrey,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }
} 