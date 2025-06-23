import 'dart:convert';
import 'package:http/http.dart' as http;

class SuggestionsService {
  Future<String> fetchDailyQuote() async {
    final response = await http.get(Uri.parse('https://zenquotes.io/api/today'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0]['q'] + ' — ' + data[0]['a'];
    } else {
      throw Exception('Failed to load quote');
    }
  }

  List<String> getMusicSuggestions() {
    return [
      'Listen to calming piano music',
      'Try a lo-fi beats playlist',
      'Explore nature sounds',
      'Enjoy your favorite uplifting song',
    ];
  }

  List<String> getSelfCareSuggestions() {
    return [
      'Take a 5-minute mindful breathing break',
      'Go for a short walk',
      "Write down three things you're grateful for",
      'Drink a glass of water',
      'Stretch your body gently',
    ];
  }
} 