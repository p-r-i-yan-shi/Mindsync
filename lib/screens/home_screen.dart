import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'suggestions_screen.dart';
import 'mood_tracking_screen.dart';
import 'profile_settings_screen.dart';
import 'ai_assistant_screen.dart';
// import 'chat_screen.dart'; // Uncomment and fix if you have a chat screen file

// Data model for Journal Entry
class JournalEntry {
  final String id;
  final String text;
  final DateTime timestamp;
  final int moodIndex;
  final String mood;

  JournalEntry({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.moodIndex,
    required this.mood,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF2A3441),
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<JournalEntry> _entries = [];
  TextEditingController _journalController = TextEditingController(text: 'hi');
  int _selectedMoodIndex = -1;

  final List<String> _moods = ['😔', '😐', '😊', '😍', '🤔'];
  final List<String> _moodLabels = ['Sad', 'Neutral', 'Happy', 'Love', 'Thinking'];

  @override
  void initState() {
    super.initState();
    // Add some sample entries
    _entries = [
      JournalEntry(
        id: '1',
        text: 'Had a wonderful day at the park with friends. The weather was perfect and I felt so grateful for these moments of joy and connection.',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        moodIndex: 2,
        mood: '😊',
      ),
      JournalEntry(
        id: '2',
        text: 'Today was just okay. Work was stressful but I managed to get through it. Looking forward to the weekend to recharge.',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        moodIndex: 1,
        mood: '😐',
      ),
      JournalEntry(
        id: '3',
        text: 'Been thinking a lot about my future goals and what I want to achieve this year. Sometimes it feels overwhelming but I know taking small steps is the key.',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        moodIndex: 4,
        mood: '🤔',
      ),
    ];
  }

  void _saveEntry() {
    if (_journalController.text.trim().isNotEmpty) {
      setState(() {
        _entries.insert(
          0,
          JournalEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: _journalController.text,
            timestamp: DateTime.now(),
            moodIndex: _selectedMoodIndex >= 0 ? _selectedMoodIndex : 2,
            mood: _selectedMoodIndex >= 0 ? _moods[_selectedMoodIndex] : '😊',
          ),
        );
        _journalController.clear();
        _selectedMoodIndex = -1;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Journal entry saved!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _expandEntry(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF34495E),
        title: Row(
          children: [
            Text(entry.mood, style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              DateFormat('MMM dd, yyyy').format(entry.timestamp),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('h:mm a').format(entry.timestamp),
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            SizedBox(height: 12),
            Text(
              entry.text,
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF34495E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey, there!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'How are you feeling today?',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF2A3441),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Quick Mood Check Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Mood Check',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_moods.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMoodIndex = index;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _selectedMoodIndex == index 
                              ? Colors.blue.withOpacity(0.3)
                              : Color(0xFF34495E),
                          borderRadius: BorderRadius.circular(30),
                          border: _selectedMoodIndex == index
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _moods[index],
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Tap to log',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Today's Journal Section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1C2833),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Journal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Voice input functionality
                      },
                      icon: Icon(
                        Icons.mic,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Container(
                  constraints: BoxConstraints(minHeight: 100),
                  child: TextField(
                    controller: _journalController,
                    maxLines: null,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Share your thoughts...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Save Entry'),
                ),
              ],
            ),
          ),

          // Recent Entries Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Recent Entries',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Entries List
          _entries.isEmpty
              ? Container(
                  margin: EdgeInsets.all(16),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF1C2833),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No journal entries yet',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Start by writing your first entry above',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () => _expandEntry(entry),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF34495E),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        entry.mood,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        DateFormat('MMM dd, yyyy').format(entry.timestamp),
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(entry.timestamp),
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                entry.text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.grey[600],
                                thickness: 0.5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Tap to expand',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          
          SizedBox(height: 100), // Bottom padding for navigation
        ],
      ),
    );
  }

  Widget _buildSuggestionsScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Suggestions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mood,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Mood Tracker',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A3441),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeScreen(),
            SuggestionsScreen(),
            AIAssistantScreen(),
            MoodTrackingScreen(),
            ProfileSettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A3441),
          border: Border(
            top: BorderSide(color: Colors.grey[800]!, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF2A3441),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              label: 'Suggestions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mood),
              label: 'Mood',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}