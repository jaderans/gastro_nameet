import 'package:flutter/material.dart';

class spbreakfast extends StatefulWidget {
  const spbreakfast({super.key});

  @override
  State<spbreakfast> createState() => _spbreakfastState();
}

class _spbreakfastState extends State<spbreakfast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right:5),
            child: Icon(Icons.free_breakfast, color: Color(0xFFFFA726)),
          ),
          Text(
            'Breakfast Specialties',
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