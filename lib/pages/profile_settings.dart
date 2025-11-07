import 'package:flutter/material.dart';
import 'package:gastro_nameet/pages/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFA726),
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right:5),
            child: Icon(Icons.account_circle, color: Color.fromARGB(255, 255, 255, 255)),
          ),
          Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Talina',
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],),
      ), // Add this line to use your custom AppBar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25.0, right: 25.0, top: 40, bottom: 0),
          child: ElevatedButton(
            onPressed: () async {
              // TODO: perform logout actions here (clear tokens, session, etc.)
              // Navigate to the login screen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const login()),
                (route) => false,
              );
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: const Color.fromARGB(255, 247, 29, 29),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ), // Padding
      ),
    );
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Navigation')),
      body: const Center(child: Text('Main Navigation Screen')),
    );
  }
}