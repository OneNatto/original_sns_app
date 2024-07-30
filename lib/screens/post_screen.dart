// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:original_sns_app/conponents/my_bottomnavi.dart';
import 'package:original_sns_app/conponents/my_post.dart';
import 'package:original_sns_app/conponents/my_textfield.dart';
import 'package:original_sns_app/provider/username_provider.dart';
import 'package:original_sns_app/services/auth/auth_service.dart';
import 'package:original_sns_app/services/post/post_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    double contentWidth;

    if (screenWidth < 600) {
      contentWidth = MediaQuery.of(context).size.width;
    } else if (screenWidth < 1200) {
      contentWidth = MediaQuery.of(context).size.width * 0.8;
    } else {
      contentWidth = MediaQuery.of(context).size.width * 0.7;
    }

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('みんなのぶつぶつ'),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            authService.signOut();
            Navigator.of(context).pushReplacementNamed('/auth_gate');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PostsList(width: contentWidth),
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
    final postService = ref.read(postServiceProvider);
    final username = ref.watch(userNameProvider);

    void addPost() async {
      postService.addPost(username, textController.text);
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
              onPressed: () => addPost(),
            ),
          ],
        ),
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  final double width;
  const PostsList({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PostService().getPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: width,
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView(
              reverse: true,
              children: snapshot.data!.docs.map((document) {
                DateTime dateTime =
                    DateFormat('yyyy-MM-dd HH:mm:ss').parse(document['time']);

                String time = DateFormat('M月d日 HH:mm').format(dateTime);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: PostWidget(
                    name: document['name'],
                    content: document['content'],
                    time: time,
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
