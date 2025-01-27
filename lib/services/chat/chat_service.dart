import 'package:cloud_firestore/cloud_firestore.dart';

//final chatServiceProvider = Provider((ref) => ChatService());

abstract class ChatService {
  Stream<QuerySnapshot> getChat(String receiverId, String senderId);
  Future sendChat(String receiverId, String senderId, String message);
}
