import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/repositories/post/post_repository.dart';

import '../models/post_model.dart';

class PostViewModel extends StateNotifier<AsyncValue<List<Post>>> {
  final PostRepository postRepository;
  StreamSubscription<QuerySnapshot>? _postSubscription;

  PostViewModel(this.postRepository) : super(const AsyncValue.loading()) {
    _getPosts();
  }

  void _getPosts() {
    _postSubscription?.cancel();
    _postSubscription = postRepository.getPost().listen((snapshot) {
      final posts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Post(
          name: data['name'] as String,
          content: data['content'] as String,
          time: data['time'] as String,
        );
      }).toList();
      state = AsyncValue.data(posts);
    }, onError: (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    });
  }

  @override
  void dispose() {
    _postSubscription?.cancel();
    super.dispose();
  }

  Future addPost(String name, String content) async {
    try {
      await postRepository.addPost(name, content);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
