import 'package:flutter/material.dart';
import 'package:gastro_nameet/components/profile_button.dart';

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
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFA726),
        title: Row(children: [
          Icon(Icons.bookmark_rounded, color: Color.fromARGB(255, 255, 255, 255)),
          Text(
            'Save',
            style: TextStyle(
              fontFamily: 'Talina',
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],),
         
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfileButton(),
          )
          
        ],
      ), // Add this line to use your custom AppBar
      body: Center(
        child: Text('Save Screen'),
      ),
    );
  }
}