import 'package:flutter/material.dart';

class spdinner extends StatefulWidget {
  const spdinner({super.key});

  @override
  State<spdinner> createState() => _spdinnerState();
}

class _spdinnerState extends State<spdinner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right:5),
            child: Icon(Icons.dinner_dining, color: Color(0xFFFFA726)),
          ),
          Text(
            'Dinner Specialties',
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