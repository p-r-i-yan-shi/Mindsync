class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  Map<String, dynamic> toMap() => {
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        text: map['text'] as String,
        isUser: map['isUser'] as bool,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
} 