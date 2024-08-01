import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:original_sns_app/repositories/post/post_repository.dart';
import 'package:original_sns_app/services/post/post_service.dart';

class PostRepositoryImpl extends PostRepository {
  final PostService postService;

  PostRepositoryImpl({required this.postService});

  @override
  Future addPost(String name, String content) =>
      postService.addPost(name, content);

  @override
  Stream<QuerySnapshot<Object?>> getPost() => postService.getPost();
}
