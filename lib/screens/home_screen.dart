import 'package:flutter/material.dart';
import 'journal_screen.dart';
import 'ai_assistant_screen.dart';
import 'profile_settings_screen.dart';
// import 'wellbeing_graph_screen.dart'; // Uncomment if you have this screen

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
      // const WellbeingGraphScreen(), // Uncomment if you have this screen
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
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI Chat'),
          // BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Wellbeing'), // Uncomment if you have this screen
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
} 