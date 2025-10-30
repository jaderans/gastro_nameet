import 'package:flutter/material.dart';
import 'dart:async';
import 'homescreen.dart';

class start extends StatefulWidget {
  const start({super.key});

  @override
  State<start> createState() => _startState();
}

class _startState extends State<start> {
  @override
  void initState() {
    super.initState();
    // Navigate to home screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAAE3B),
              Color(0xFFF7941D),
            ],
          ),
        ),
        child: Center(
          child: Column(children: [
            SizedBox(height: 300,),
            Image.asset('assets/images/gastro_mainwhite.png', height: 200, width: 200,),
          ],)
        ),
      ),
    );
  }
}