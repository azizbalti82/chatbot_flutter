class Message {
  final String id;
  final bool isUser;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.isUser,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
