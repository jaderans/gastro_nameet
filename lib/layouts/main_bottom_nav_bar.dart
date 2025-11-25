import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../pages/home/homescreen.dart';
import '../pages/maps/food.dart';
import '../pages/activities/bookmark_display.dart';
import '../pages/events/notification.dart';
import '../pages/activities/comments_display.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Home(),
    Food(),
    Bookmark(),
    NotificationsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
