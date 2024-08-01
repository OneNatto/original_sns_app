// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:original_sns_app/components/my_bottomnavi.dart';
import 'package:original_sns_app/components/my_post.dart';
import 'package:original_sns_app/components/my_textfield.dart';
import 'package:original_sns_app/provider/auth_provider.dart';
import 'package:original_sns_app/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/post_model.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    double contentWidth;

    if (screenWidth < 600) {
      contentWidth = MediaQuery.of(context).size.width;
    } else if (screenWidth < 1200) {
      contentWidth = MediaQuery.of(context).size.width * 0.8;
    } else {
      contentWidth = MediaQuery.of(context).size.width * 0.7;
    }

    final postState = ref.watch(postViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('みんなのぶつぶつ'),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            authViewModel.signOut();
            Navigator.of(context).pushReplacementNamed('/auth_gate');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            //child: PostsList(width: contentWidth),
            child: postState.when(
                data: (posts) {
                  return PostsList(
                    width: contentWidth,
                    posts: posts,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error'))),
          ),
          PostAdd(),
        ],
      ),
      bottomNavigationBar: const MyBottomNavigation(
        currentIndex: 0,
      ),
    );
  }
}

class PostAdd extends ConsumerWidget {
  PostAdd({
    super.key,
  });

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postViewModel = ref.read(postViewModelProvider.notifier);
    final username = ref.watch(userNameProvider);

    void addPost() async {
      postViewModel.addPost(username, textController.text);
      textController.clear();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: MyField(
                hintText: 'ぶつぶつ,,,',
                obscureText: false,
                controller: textController,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (textController.text != "") {
                  addPost();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  final double width;
  final List<Post> posts;
  const PostsList({
    Key? key,
    required this.width,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView(
        reverse: true,
        children: posts.map((post) {
          DateTime dateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(post.time);

          String time = DateFormat('M月d日 HH:mm').format(dateTime);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: PostWidget(
              name: post.name,
              content: post.content,
              time: time,
            ),
          );
        }).toList(),
      ),
    );
  }
}
