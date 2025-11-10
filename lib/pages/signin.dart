import 'package:flutter/material.dart';
import 'package:gastro_nameet/layouts/main_bottom_nav_bar.dart';
import 'package:gastro_nameet/pages/startscreen.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/signin_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('assets/images/batchoy_welcome.png'),
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(height: 10),
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
                    padding: const EdgeInsets.only(top: 0, bottom: 3),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontFamily: 'Talina',
                        height: 1,
                        fontSize: 47,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFAAD3B),
                      ),
                    ),
                  ),
                  Text(
                    'Press Sign Up to continue',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      height: 1,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(255, 166, 166, 166),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20, bottom: 0),
                    child: Focus(
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return TextFormField(
                            controller: _nameController,
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                              hintText: "Name",
                              labelText: "Name",
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 208, 208, 208)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFFF7941D)),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 12,
                                color: hasFocus ? Color(0xFFF7941D) : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10, bottom: 0),
                    child: Focus(
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return TextFormField(
                            controller: _emailController,
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                              hintText: "Email",
                              labelText: "Email",
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 208, 208, 208)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFFF7941D)),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 12,
                                color: hasFocus ? Color(0xFFF7941D) : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10, bottom: 0),
                    child: Focus(
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                              hintText: "Password",
                              labelText: "Password",
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 208, 208, 208)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xFFF7941D)),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 12,
                                color: hasFocus ? Color(0xFFF7941D) : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25, bottom: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle login logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainNavigation(),
                          ),
                        );
                      },
                      child: Text("Sign up", style: TextStyle(color: Colors.white)),
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
                        left: 30.0, right: 30.0, top: 10, bottom: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle login logic h1ere
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const start(),
                          ),
                        );
                      },
                      child:
                      Text("< Go Back", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Color.fromARGB(255, 153, 151, 148),
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
          ),
        ],
      ),
    );
  }
}