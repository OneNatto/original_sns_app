// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:original_sns_app/screens/auth/login_screen.dart';
import 'package:original_sns_app/screens/auth/register_screen.dart';

import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  final String? error;
  const LoginOrRegister({super.key, this.error});

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
