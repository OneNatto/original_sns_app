import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:original_sns_app/services/chat/chat_service.dart';

import 'chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatService chatService;

  ChatRepositoryImpl({required this.chatService});

  @override
  Stream<QuerySnapshot<Object?>> getChat(String receiverId, String senderId) =>
      chatService.getChat(receiverId, senderId);

  @override
  Future sendChat(String receiverId, String senderId, String message) =>
      chatService.sendChat(receiverId, senderId, message);
}
