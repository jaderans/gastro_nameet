import 'package:flutter/material.dart';

class spsnacks extends StatefulWidget {
  const spsnacks({super.key});

  @override
  State<spsnacks> createState() => _spsnacksState();
}

class _spsnacksState extends State<spsnacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right:5),
            child: Icon(Icons.fastfood, color: Color(0xFFFFA726)),
          ),
          Text(
            'Snacks Specialties',
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