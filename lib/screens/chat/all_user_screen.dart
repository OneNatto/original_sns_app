import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/components/my_bottomnavi.dart';
import 'package:original_sns_app/provider/auth_provider.dart';
import 'package:original_sns_app/screens/chat/chat_screen.dart';

class AllUserScreen extends ConsumerWidget {
  const AllUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final FirebaseAuth auth = FirebaseAuth.instance;
    final loginedUser = auth.currentUser;
    //サービス
    final authViewModel = ref.read(authViewModelProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('チャット'),
        leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              authViewModel.signOut();
              Navigator.of(context).pushReplacementNamed('/auth_gate');
            }),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData) {
            final List<DocumentSnapshot> filteredDocs =
                snapshot.data!.docs.where((document) {
              return loginedUser!.uid != document['id'];
            }).toList();
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(5.0),
              child: screenWidth < 600
                  ? ListView(
                      children: filteredDocs.map((document) {
                        return ChatUser(
                          text: document['name'],
                          receiverId: document['id'],
                          receiverName: document['name'],
                        );
                      }).toList(),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 7,
                      ),
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final document = filteredDocs[index];

                        return SizedBox(
                          height: 200,
                          child: ChatUser(
                            text: document['name'],
                            receiverId: document['id'],
                            receiverName: document['name'],
                          ),
                        );
                      },
                    ),
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavigation(
        currentIndex: 1,
      ),
    );
  }
}

class ChatUser extends StatelessWidget {
  final String text;
  final String receiverId;
  final String receiverName;

  const ChatUser({
    Key? key,
    required this.text,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                  receiverId: receiverId, receiverName: receiverName)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 2),
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.people),
            ),
            const SizedBox(width: 10),
            Text(
              text,
            )
          ],
        ),
      ),
    );
  }
}
