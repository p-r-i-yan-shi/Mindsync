import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[
    ChatMessage(
      text: 'Hello! How can I help you reflect on your day or understand your journal entries?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final String userMessageText = _textController.text.trim();
    if (userMessageText.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        ChatMessage(
          text: userMessageText,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
      _textController.clear();
    });

    _scrollToBottom();

    // Simulate AI response
    await Future<void>.delayed(const Duration(seconds: 2));

    String aiResponse;
    if (userMessageText.toLowerCase().contains('how are you')) {
      aiResponse = 'I am an AI, so I don\'t have feelings, but I\'m ready to assist you!';
    } else if (userMessageText.toLowerCase().contains('journal')) {
      aiResponse = 'What about your journal would you like to discuss? I can help you analyze patterns or suggest prompts.';
    } else if (userMessageText.toLowerCase().contains('mood')) {
      aiResponse = 'Understanding your mood is important. Would you like to explore why you\'re feeling a certain way?';
    } else if (userMessageText.toLowerCase().contains('hello') || userMessageText.toLowerCase().contains('hi')) {
      aiResponse = 'Hi there! How can I assist you today?';
    } else {
      aiResponse = 'That\'s an interesting thought. Can you tell me more about what you\'re trying to achieve?';
    }

    setState(() {
      _messages.add(
        ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()),
      );
      _isLoading = false;
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Talk to NUMA',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final ChatMessage message = _messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.text,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: message.isUser
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: message.isUser
                                    ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                _isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
