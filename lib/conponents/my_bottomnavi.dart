import 'package:flutter/material.dart';

class MyBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const MyBottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.grey[200],
      unselectedItemColor: Colors.grey[600],
      items: [
        BottomNavigationBarItem(
          label: 'みんなのつぶやき',
          icon: SizedBox(
            width: width,
            height: 40,
            child: InkWell(
              child: const Center(
                child: Icon(Icons.chat),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/post');
              },
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: 'トーク',
          icon: SizedBox(
            width: width,
            height: 40,
            child: InkWell(
              child: const Center(
                child: Icon(Icons.chat),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/talk');
              },
            ),
          ),
        ),
      ],
    );
  }
}
