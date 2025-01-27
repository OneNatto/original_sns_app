import 'package:cloud_firestore/cloud_firestore.dart';

//final postServiceProvider = Provider((ref) => PostService());

abstract class PostService {
  Future addPost(String name, String content);
  Stream<QuerySnapshot> getPost();
}
