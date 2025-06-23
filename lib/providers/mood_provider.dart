import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mood_log.dart';
import '../services/mood_service.dart';

final moodServiceProvider = Provider((ref) => MoodService());

final moodLogsProvider = StreamProvider<List<MoodLog>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();
  return ref.watch(moodServiceProvider).getMoods(user.uid);
});

final addMoodLogProvider = FutureProvider.family<void, MoodLog>((ref, log) async {
  await ref.watch(moodServiceProvider).addMood(log);
});

final deleteMoodLogProvider = FutureProvider.family<void, String>((ref, id) async {
  await ref.watch(moodServiceProvider).deleteMood(id);
}); 