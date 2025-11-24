import 'package:flutter/material.dart';

class splunch extends StatefulWidget {
  const splunch({super.key});

  @override
  State<splunch> createState() => _splunchState();
}

class _splunchState extends State<splunch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right:5),
            child: Icon(Icons.lunch_dining, color: Color(0xFFFFA726)),
          ),
          Text(
            'Lunch Specialties',
            style: TextStyle(
              fontFamily: 'Talina',
              fontWeight: FontWeight.w100,
              color: Color(0xFFFFA726),
            ),
          ),
        ],
      ),
      )
    );
  }
}