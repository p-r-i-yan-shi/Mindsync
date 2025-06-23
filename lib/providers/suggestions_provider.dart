import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/suggestions_service.dart';

final suggestionsServiceProvider = Provider((ref) => SuggestionsService());

final dailyQuoteProvider = FutureProvider<String>((ref) async {
  return ref.watch(suggestionsServiceProvider).fetchDailyQuote();
});

final musicSuggestionsProvider = Provider<List<String>>((ref) {
  return ref.watch(suggestionsServiceProvider).getMusicSuggestions();
});

final selfCareSuggestionsProvider = Provider<List<String>>((ref) {
  return ref.watch(suggestionsServiceProvider).getSelfCareSuggestions();
}); 