import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';


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
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // keeps all labels visible
        backgroundColor: Colors.white, // bar background color
        selectedItemColor: const Color.fromARGB(255, 255, 183, 68), // selected color
        unselectedItemColor: const Color.fromARGB(255, 177, 177, 177), // unselected color
        selectedFontSize: 13,
        unselectedFontSize: 13,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(0,0,0,0),
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(0,0,0,0),
        ),
        iconSize: 28,
        elevation: 50,
        currentIndex: currentIndex,
        onTap:onTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Symbols.home_rounded,
               fill: 1,
               weight: 700,  
               grade: -25,
               opticalSize: 48,
              ),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Symbols.fastfood_rounded,
              fill: 1,
              weight: 700,  
              grade: -25,
              opticalSize: 48,
            ),
            label: 'Food',

          ),
          BottomNavigationBarItem(
            icon: Icon(
              Symbols.bookmark_rounded,
              fill: 1,
              weight: 700,  
              grade: -25,
              opticalSize: 48,
            ),
            label: 'Save',

          ),
          BottomNavigationBarItem(
            icon: Icon(
              Symbols.notifications_rounded,
                fill: 1,
                weight: 700,  
                grade: -25,
                opticalSize: 48,
            ),
            label: 'Events',
            
          ),
        ],
      ),
    );
  }
  
}
