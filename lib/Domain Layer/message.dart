// domain/entities/message.dart
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Message {
  final types.User author;
  final int createdAt;
  final String id;
  final String text;

  Message({
    required this.author,
    required this.createdAt,
    required this.id,
    required this.text,
  });
}

