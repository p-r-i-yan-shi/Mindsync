import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart'; // For AppColors

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // Placeholder for chat messages

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({'text': _messageController.text, 'isUser': true});
        _messageController.clear();
        // Simulate AI response
        _messages.add({'text': 'Hello! How can I help you today?', 'isUser': false});
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'Talk to AI',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textColor,
                fontSize: 22,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // AI Suggestion Cards
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildSuggestionCard('Play a calming song', Icons.music_note),
                _buildSuggestionCard('Suggest a breathing exercise', Icons.self_improvement),
                _buildSuggestionCard('Give me an affirmation', Icons.favorite_outline),
                _buildSuggestionCard('Tell me a joke', Icons.sentiment_very_satisfied),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message['isUser'] ? AppColors.accentPurple : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: AppColors.lightGrey),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: AppColors.accentPurple, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: AppColors.accentPurple),
                        onPressed: _sendMessage,
                      ),
                    ),
                    style: TextStyle(color: AppColors.textColor),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () {
                    // Handle mic input (speech-to-text)
                    print('Mic button pressed for AI chat');
                  },
                  backgroundColor: AppColors.accentPurple,
                  mini: true,
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String title, IconData icon) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          print('AI Suggestion: $title');
          // TODO: Implement AI suggestion logic
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: AppColors.accentPurple),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(color: AppColors.textColor, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 