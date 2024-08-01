import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/viewmodels/post_viewmodel.dart';

import '../models/post_model.dart';
import '../repositories/post/post_repository_impl.dart';
import '../services/post/post_service_impl.dart';

final postServiceProvider = Provider<PostServiceImpl>((ref) {
  return PostServiceImpl();
});

final postRepositoryProvider = Provider<PostRepositoryImpl>((ref) {
  final postService = ref.watch(postServiceProvider);
  return PostRepositoryImpl(postService: postService);
});

final postViewModelProvider =
    StateNotifierProvider<PostViewModel, AsyncValue<List<Post>>>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostViewModel(postRepository);
});
