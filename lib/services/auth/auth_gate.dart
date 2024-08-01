import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:original_sns_app/provider/auth_provider.dart';
import 'package:original_sns_app/screens/auth/login_or_register.dart';
import 'package:original_sns_app/screens/post/post_screen.dart';

class AuhtGate extends ConsumerWidget {
  const AuhtGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    return authState.when(
      data: (user) {
        if (user != null) {
          return const PostScreen();
        } else {
          return const LoginOrRegister();
        }
      },
      error: (e, stackTrace) {
        return Center(child: Text("エラーが起きました。$e"));
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
