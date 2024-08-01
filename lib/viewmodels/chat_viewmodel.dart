// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:original_sns_app/repositories/chat/chat_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_message_model.dart';

class ChatViewModel extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final ChatRepository chatRepository;
  final String receiverId;
  final String senderId;
  StreamSubscription<QuerySnapshot>? _chatSubscription;

  ChatViewModel(
    this.chatRepository, {
    required this.receiverId,
    required this.senderId,
  }) : super(const AsyncValue.loading()) {
    getChat();
  }

  void getChat() {
    _chatSubscription?.cancel();
    _chatSubscription =
        chatRepository.getChat(receiverId, senderId).listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatMessage(
          content: data['content'],
          senderId: data['senderId'],
          time: data['time'],
        );
      }).toList();
      state = AsyncValue.data(messages);
    }, onError: (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    });
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }

  Future<void> sendChat(
      String receiverId, String senderId, String message) async {
    try {
      await chatRepository.sendChat(receiverId, senderId, message);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
