import 'package:flutter/material.dart';
import 'package:gastro_nameet/pages/signin.dart';
import 'package:gastro_nameet/pages/loginstart.dart';

class start extends StatefulWidget {
  const start({super.key});

  @override
  State<start> createState() => _startState();
}

class _startState extends State<start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/startscreen_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Buttons at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Text(
                    'Maayong Adlaw!',
                    style: TextStyle(
                      fontFamily: 'Talina',
                      height: 1,
                      fontSize: 18,
                      color: Color(0xFFBC6600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 3),
                    child: Text(
                      'This is Gastro Nameet',
                      style: TextStyle(
                        fontFamily: 'Talina',
                        height: 1,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFAAD3B),
                      ),
                    ),
                  ),
                  Text(
                    'Craving something authentic?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      height: 1,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 166, 166, 166),
                    ),
                  ),
                  SizedBox(height: 10),
                  Image(
                    image: AssetImage('assets/images/batchoy_welcome.png'),
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 0, bottom: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const loginstart(),
                        ),
                      );
                    },
                    child: Text("Log In", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Color(0xFFF7941D),
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 0, bottom: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const signin(),
                        ),
                      );
                    },
                    child: Text("Get Started", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Color.fromARGB(255, 239, 117, 17),
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}