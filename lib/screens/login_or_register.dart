import 'package:flutter/material.dart';
import 'package:original_sns_app/screens/login_screen.dart';
import 'package:original_sns_app/screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;
  void onPressed() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginScreen(onPressed: onPressed);
    } else {
      return RegisterScreen(onPressed: onPressed);
    }
  }
}
