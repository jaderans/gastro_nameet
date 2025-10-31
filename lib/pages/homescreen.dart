import 'package:flutter/material.dart';
import 'package:gastro_nameet/componets/bottom_nav_bar.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gastro Nameet'),
      ), // Add this line to use your custom AppBar
      body: Center(
        child: Text('Home Screen'),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation logic here
        },
      ),
    );
  }
}

