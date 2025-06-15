import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart'; // For AppColors

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final TextEditingController _journalController = TextEditingController();

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'New Journal Entry',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                controller: _journalController,
                maxLines: null, // Allows unlimited lines
                expands: true, // Takes up available space
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind today?',
                  hintStyle: TextStyle(color: AppColors.lightGrey),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.accentPurple, width: 2),
                  ),
                ),
                style: TextStyle(color: AppColors.textColor),
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for emoji-based mood selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('😊', style: TextStyle(fontSize: 30)),
                Text('😢', style: TextStyle(fontSize: 30)),
                Text('😠', style: TextStyle(fontSize: 30)),
                Text('😴', style: TextStyle(fontSize: 30)),
                Text('😌', style: TextStyle(fontSize: 30)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle journal submission
                print('Journal Entry: ${_journalController.text}');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Full width button
                // Add gradient and shadow later as per UI kit
              ),
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle mic input (speech-to-text)
          print('Mic button pressed');
        },
        backgroundColor: AppColors.accentPurple,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
} 