class Message {
  final String text;
  final bool isUser; // true kung ikaw, false kung si Ventify
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
