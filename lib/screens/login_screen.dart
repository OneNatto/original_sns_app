import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:original_sns_app/conponents/my_button.dart';
import 'package:original_sns_app/conponents/my_textfield.dart';
import 'package:original_sns_app/services/auth/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  final void Function()? onPressed;

  LoginScreen({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      contentWidth = MediaQuery.of(context).size.width * 0.5;
    }

    void loginFunction() async {
      final result = await authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ログインに失敗しました。正しいメールアドレスとパスワードを入力してください。'),
          ),
        );

        emailController.clear();
        passwordController.clear();
      }
    }

    return Scaffold(
      body: Center(
        child: Container(
          width: contentWidth,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //ロゴ
              SizedBox(
                width: 150,
                child: Lottie.asset('assets/lottie/Aniki Hamster.json'),
              ),

              //Eメール入力ボックス
              MyField(
                hintText: 'メールアドレスを入力',
                obscureText: false,
                controller: emailController,
              ),

              const SizedBox(height: 15),

              //パスワード入力ボックス
              MyField(
                hintText: 'パスワードを入力',
                obscureText: true,
                controller: passwordController,
              ),

              const SizedBox(height: 20),

              //ボタン
              MyButton(
                onTap: loginFunction,
                text: 'ログイン',
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'アカウントをお持ちでない方｜',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  TextButton(
                    onPressed: onPressed,
                    child: Text(
                      'こちら',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
