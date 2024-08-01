import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
