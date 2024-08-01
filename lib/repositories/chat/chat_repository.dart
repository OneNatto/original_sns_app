import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatRepository {
  Stream<QuerySnapshot> getChat(String receiverId, String senderId);
  Future sendChat(String receiverId, String senderId, String message);
}
