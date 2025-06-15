import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart'; // For AppColors

class QuoteSuggestionsScreen extends StatefulWidget {
  const QuoteSuggestionsScreen({super.key});

  @override
  State<QuoteSuggestionsScreen> createState() => _QuoteSuggestionsScreenState();
}

class _QuoteSuggestionsScreenState extends State<QuoteSuggestionsScreen> {
  final List<String> _quotes = [
    "The only way to do great work is to love what you do. - Steve Jobs",
    "Believe you can and you're halfway there. - Theodore Roosevelt",
    "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
    "It is during our darkest moments that we must focus to see the light. - Aristotle Onassis",
    "Strive not to be a success, but rather to be of value. - Albert Einstein",
  ];
  int _currentQuoteIndex = 0;

  void _nextQuote() {
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'Quotes & Suggestions',
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
              child: Center(
                child: Card(
                  color: AppColors.cardBackground,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _quotes[_currentQuoteIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textColor, fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border, color: AppColors.accentPurple),
                              onPressed: () {
                                // TODO: Implement save/favorite quote
                                print('Favorite quote: ${_quotes[_currentQuoteIndex]}');
                              },
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _nextQuote,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentPurple, // Button background color
                                foregroundColor: Colors.white, // Button text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                              ),
                              child: const Text('Next Quote', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Daily Suggestions:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 10),
            // Placeholder for suggestions list
            Expanded(
              child: ListView(
                children: [
                  _buildSuggestionItem('Try a 5-minute meditation', Icons.self_improvement),
                  _buildSuggestionItem('Write down 3 things you are grateful for', Icons.edit_note),
                  _buildSuggestionItem('Take a short walk outside', Icons.directions_walk),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion, IconData icon) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accentPurple),
        title: Text(suggestion, style: TextStyle(color: AppColors.textColor)),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.lightGrey),
        onTap: () {
          print('Suggestion tapped: $suggestion');
          // TODO: Implement suggestion action
        },
      ),
    );
  }
} 