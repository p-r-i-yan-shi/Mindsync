import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

final chatServiceProvider = Provider((ref) => ChatService());

final chatMessagesProvider = StreamProvider<List<ChatMessage>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();
  return ref.watch(chatServiceProvider).getMessages(user.uid);
});

final sendChatMessageProvider = FutureProvider.family<void, String>((ref, message) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  final history = await ref.watch(chatMessagesProvider.future);
  await ref.watch(chatServiceProvider).sendMessage(
    userId: user.uid,
    message: message,
    history: history,
  );
}); 