import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String content;
  final String senderId;
  final Timestamp time;

  ChatMessage({
    required this.content,
    required this.senderId,
    required this.time,
  });
}
