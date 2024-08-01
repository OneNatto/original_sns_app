import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/firebase_options.dart';
import 'package:original_sns_app/screens/splash_screen.dart';
import 'package:original_sns_app/services/auth/auth_gate.dart';

import 'screens/chat/all_user_screen.dart';
import 'screens/post/post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashScreen(),
        routes: {
          '/post': (context) => const PostScreen(),
          '/talk': (context) => const AllUserScreen(),
          '/auth_gate': (context) => const AuhtGate(),
        });
  }
}
