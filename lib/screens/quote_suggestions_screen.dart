import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/suggestions_provider.dart';

class QuoteSuggestionsScreen extends ConsumerWidget {
  const QuoteSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(dailyQuoteProvider);
    final musicSuggestions = ref.watch(musicSuggestionsProvider);
    final selfCareSuggestions = ref.watch(selfCareSuggestionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Suggestions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: quoteAsync.when(
              data: (quote) => SuggestionCard(
                key: const ValueKey('quote'),
                title: 'Daily Quote',
                content: quote,
                icon: Icons.format_quote,
                color: Colors.purpleAccent,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => SuggestionCard(
                key: const ValueKey('quote-error'),
                title: 'Daily Quote',
                content: 'Could not load quote.',
                icon: Icons.error_outline,
                color: Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SuggestionCard(
            title: 'Music Suggestion',
            content: musicSuggestions.first,
            icon: Icons.music_note,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 24),
          ...selfCareSuggestions.take(2).map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SuggestionCard(
                  title: 'Self-Care',
                  content: s,
                  icon: Icons.spa,
                  color: Colors.greenAccent,
                ),
              )),
        ],
      ),
    );
  }
}

class SuggestionCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const SuggestionCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
              radius: 28,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(content, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 