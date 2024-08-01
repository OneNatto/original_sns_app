import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:original_sns_app/components/my_button.dart';
import 'package:original_sns_app/components/my_textfield.dart';
import 'package:original_sns_app/provider/auth_provider.dart';

class RegisterScreen extends ConsumerWidget {
  final void Function()? onPressed;

  RegisterScreen({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      contentWidth = MediaQuery.of(context).size.width * 0.5;
    }

    Future registerFunction() async {
      final result = await authViewModel.signUp(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('登録に失敗しました。メールアドレスかパスワードの形式に誤りがあります。'),
          ),
        );

        nameController.clear();
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

              //ユーザー名前入力ボックス
              MyField(
                hintText: 'ユーザーネームを入力',
                obscureText: false,
                controller: nameController,
              ),

              const SizedBox(height: 10),

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
                onTap: registerFunction,
                text: '登録',
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'アカウントをお持ちの方｜',
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
