import 'package:flutter/material.dart';
import 'package:gastro_nameet/components/profile_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        backgroundColor: Color(0xFFFFA726),
        title: Image(image: AssetImage('assets/images/gastro_title.png'), height: 30,),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfileButton(),
          )
          
        ],
      ), // Add this line to use your custom AppBar
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

