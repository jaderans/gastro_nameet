import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(), // Add this line to use your custom AppBar
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

class AppBarScreen extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  AppBarScreen({Key? key}) 
    : preferredSize = const Size.fromHeight(56.0), 
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('AppBarScreen'),
      automaticallyImplyLeading: true,
    );
  }
}