import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'post_service.dart';

class PostServiceImpl extends PostService {
  //インスタンス
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //投稿を追加
  @override
  Future addPost(String name, String content) async {
    final time = Timestamp.now();

    final localTime = time.toDate();

    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(localTime);

    firestore.collection('posts').doc().set({
      'name': name,
      'content': content,
      'time': formattedTime,
    });
  }

  @override
  Stream<QuerySnapshot> getPost() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('time', descending: false)
        .snapshots();
  }
}
