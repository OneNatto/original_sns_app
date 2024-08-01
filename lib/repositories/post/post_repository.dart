import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PostRepository {
  Future addPost(String name, String content);
  Stream<QuerySnapshot> getPost();
}
