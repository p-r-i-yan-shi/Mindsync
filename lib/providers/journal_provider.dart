import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';

final journalServiceProvider = Provider((ref) => JournalService());

final journalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();
  return ref.watch(journalServiceProvider).getEntries(user.uid);
});

final addJournalEntryProvider = FutureProvider.family<void, JournalEntry>((ref, entry) async {
  await ref.watch(journalServiceProvider).addEntry(entry);
});

final deleteJournalEntryProvider = FutureProvider.family<void, String>((ref, id) async {
  await ref.watch(journalServiceProvider).deleteEntry(id);
}); 