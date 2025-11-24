import 'package:flutter/material.dart';

class spdessert extends StatefulWidget {
  const spdessert({super.key});

  @override
  State<spdessert> createState() => __spdesserStateState();
}

class __spdesserStateState extends State<spdessert> {
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