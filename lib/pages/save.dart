import 'package:flutter/material.dart';

class Save extends StatefulWidget {
  const Save({super.key});

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gastro Nameet'),
      ), // Add this line to use your custom AppBar
      body: Center(
        child: Text('Save Screen'),
      ),
    );
  }
}