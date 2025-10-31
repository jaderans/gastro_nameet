import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // keeps all labels visible
      backgroundColor: Colors.white, // bar background color
      selectedItemColor: const Color.fromARGB(255, 255, 183, 68), // selected color
      unselectedItemColor: const Color.fromARGB(255, 84, 84, 84), // unselected color
      selectedFontSize: 14,
      unselectedFontSize: 12,
      iconSize: 28,
      elevation: 10,
      currentIndex: currentIndex,
      onTap:onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fastfood),
          label: 'Food',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Save',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Settings',
        ),
      ],
    );
  }
  
}
