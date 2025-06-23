class ChatMessage {
  final String id;
  final String userId;
  final String sender; // 'user' or 'numa'
  final String message;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.sender,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'sender': sender,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] as String,
        userId: map['userId'] as String,
        sender: map['sender'] as String,
        message: map['message'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
} 