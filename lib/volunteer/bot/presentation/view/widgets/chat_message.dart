enum MessageSender { user, bot }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<String> quickActions;

  ChatMessage({
    required this.text,
    required this.sender,
    DateTime? timestamp,
    this.quickActions = const [],
  }) : timestamp = timestamp ?? DateTime.now();
}
