import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider((ref) => ChatService());

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //チャットルーム取得
  Stream<QuerySnapshot> getChat(String receiverId, String senderId) {
    List<String> ids = [receiverId, senderId];
    ids.sort();

    String roomId = ids.join('_');

    final chat = firestore
        .collection('chatrooms')
        .doc(roomId)
        .collection('chat')
        .orderBy('time', descending: false)
        .snapshots();

    return chat;
  }

  //チャットルームの作成＆メッセージの追加
  void sendChat(String receiverId, String senderId, String message) async {
    final ids = [receiverId, senderId];
    ids.sort();

    String roomId = ids.join('_');

    final timestamp = Timestamp.now();

    firestore.collection('chatrooms').doc(roomId).collection('chat').add({
      'content': message,
      'senderId': senderId,
      'time': timestamp,
    });
  }
}
