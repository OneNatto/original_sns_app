import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/repositories/chat/chat_repository_impl.dart';
import 'package:original_sns_app/services/chat/chat_service_impl.dart';
import 'package:original_sns_app/viewmodels/chat_viewmodel.dart';
import 'package:dartz/dartz.dart';

import '../models/chat_message_model.dart';

final chatServiceProvider = Provider<ChatServiceImpl>((ref) {
  return ChatServiceImpl();
});

final chatRepositoryProvider = Provider<ChatRepositoryImpl>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatRepositoryImpl(chatService: chatService);
});

final chatViewModelProvider = StateNotifierProvider.family<ChatViewModel,
    AsyncValue<List<ChatMessage>>, Tuple2<String, String>>((ref, ids) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatViewModel(
    chatRepository,
    receiverId: ids.value1,
    senderId: ids.value2,
  );
});
