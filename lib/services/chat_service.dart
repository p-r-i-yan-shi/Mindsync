import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';

class ChatService {
  final _db = FirebaseFirestore.instance;
  final String collection = 'chat_messages';

  Stream<List<ChatMessage>> getMessages(String userId) {
    return _db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage({
    required String userId,
    required String message,
    required List<ChatMessage> history,
  }) async {
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      userId: userId,
      sender: 'user',
      message: message,
      createdAt: DateTime.now(),
    );
    await _db.collection(collection).doc(userMsg.id).set(userMsg.toMap());

    // Prepare conversation history for OpenAI
    final openaiHistory = history
        .map((m) => {
              'role': m.sender == 'user' ? 'user' : 'assistant',
              'content': m.message,
            })
        .toList();
    openaiHistory.add({'role': 'user', 'content': message});

    final apiKey = dotenv.env['OPENAI_API_KEY'];
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are Numa, an empathetic, emotionally intelligent AI friend. Reply like a real friend, remember the user\'s past moods and context, and be supportive and conversational.',
          },
          ...openaiHistory,
        ],
        'max_tokens': 120,
        'temperature': 0.85,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'] as String;
      final numaMsg = ChatMessage(
        id: const Uuid().v4(),
        userId: userId,
        sender: 'numa',
        message: reply.trim(),
        createdAt: DateTime.now(),
      );
      await _db.collection(collection).doc(numaMsg.id).set(numaMsg.toMap());
    } else {
      throw Exception('Failed to get Numa\'s reply');
    }
  }
} 