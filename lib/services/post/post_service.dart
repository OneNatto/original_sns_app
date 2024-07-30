import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final postServiceProvider = Provider((ref) => PostService());

class PostService {
  //インスタンス
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //投稿を追加
  void addPost(String name, String content) {
    final time = Timestamp.now();

    final localTime = time.toDate();

    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(localTime);

    firestore.collection('posts').doc().set({
      'name': name,
      'content': content,
      'time': formattedTime,
    });
  }

  Stream<QuerySnapshot> getPost() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: false)
        .snapshots();
  }
}
