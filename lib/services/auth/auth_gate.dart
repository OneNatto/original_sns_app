import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:original_sns_app/screens/login_or_register.dart';
import 'package:original_sns_app/screens/post_screen.dart';

class AuhtGate extends StatelessWidget {
  const AuhtGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const PostScreen();
        } else {
          return const LoginOrRegister();
        }
      },
    );
  }
}
