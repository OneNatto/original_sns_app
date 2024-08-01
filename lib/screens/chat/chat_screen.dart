import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:original_sns_app/components/my_textfield.dart';
import 'package:original_sns_app/models/chat_message_model.dart';
import 'package:original_sns_app/provider/chat_provider.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ゆーざー情報
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? loginedUser = auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(receiverName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ChatList(receiverId: receiverId, senderId: loginedUser!.uid),
          ),
          SendChat(receiverId: receiverId, senderId: loginedUser.uid),
        ],
      ),
    );
  }
}

class ChatList extends ConsumerWidget {
  final String receiverId;
  final String senderId;

  const ChatList({
    super.key,
    required this.receiverId,
    required this.senderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatViewModel =
        ref.watch(chatViewModelProvider(Tuple2(receiverId, senderId)));

    return chatViewModel.when(
      data: (chats) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatMessage = chats[index];
              final prevChat = index != 0 ? chats[index - 1] : null;

              bool isDateInfo = index == 0 ||
                  chatMessage.time.toDate().day != prevChat!.time.toDate().day;

              if (isDateInfo) {
                final datetime = chatMessage.time.toDate();
                String date =
                    '${datetime.year}年${datetime.month}月${datetime.day}日';
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    chatBubble(context, chatMessage),
                  ],
                );
              } else {
                return chatBubble(context, chatMessage);
              }
            },
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text('エラーが発生しました: $error'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget chatBubble(BuildContext context, ChatMessage chatMessage) {
    bool condition = chatMessage.senderId == senderId;
    final alignment = chatMessage.senderId == senderId
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    Timestamp timestamp = chatMessage.time;
    String time = DateFormat("HH:mm").format(timestamp.toDate());

    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: alignment,
          children: condition
              ? [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chatMessage.content,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const CircleAvatar(
                    child: Icon(Icons.people),
                  ),
                ]
              : [
                  const CircleAvatar(
                    child: Icon(Icons.people),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      chatMessage.content,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ]),
    );
  }
}

class SendChat extends ConsumerWidget {
  final TextEditingController textController = TextEditingController();
  final String receiverId;
  final String senderId;

  SendChat({
    super.key,
    required this.receiverId,
    required this.senderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatViewModel =
        ref.watch(chatViewModelProvider(Tuple2(receiverId, senderId)).notifier);

    void sendChat() {
      chatViewModel.sendChat(receiverId, senderId, textController.text);
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
                hintText: '',
                obscureText: false,
                controller: textController,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (textController.text != "") {
                  sendChat();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _ChatMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //これを忘れていた

  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            data['content'],
          ),
          const SizedBox(height: 4),
        ],
      ),
    ),
  );
}
