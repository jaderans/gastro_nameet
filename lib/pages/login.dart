import 'package:flutter/material.dart';
import 'package:gastro_nameet/layouts/main_bottom_nav_bar.dart';
import 'package:gastro_nameet/pages/signin.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.15),
                      Text(
                        'Maayong Adlaw!',
                        style: TextStyle(
                          fontFamily: 'Talina',
                          height: 1,
                          fontSize: screenWidth * 0.045,
                          color: Color(0xFFBC6600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.005,
                          bottom: screenHeight * 0.01,
                        ),
                        child: Text(
                          'LOG IN',
                          style: TextStyle(
                            fontFamily: 'Talina',
                            height: 1,
                            fontSize: screenWidth * 0.12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFAAD3B),
                          ),
                        ),
                      ),
                      Text(
                        'Press Log In to continue',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          height: 1,
                          fontSize: screenWidth * 0.025,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 166, 166, 166),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Focus(
                        child: Builder(
                          builder: (context) {
                            final hasFocus = Focus.of(context).hasFocus;
                            return TextFormField(
                              controller: _emailController,
                              obscureText: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                  horizontal: 10,
                                ),
                                hintText: "Email",
                                labelText: "Email",
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: const Color.fromARGB(255, 208, 208, 208),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xFFF7941D)),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: hasFocus ? Color(0xFFF7941D) : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Focus(
                        child: Builder(
                          builder: (context) {
                            final hasFocus = Focus.of(context).hasFocus;
                            return TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                  horizontal: 10,
                                ),
                                hintText: "Password",
                                labelText: "Password",
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: const Color.fromARGB(255, 208, 208, 208),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xFFF7941D)),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: hasFocus ? Color(0xFFF7941D) : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavigation(),
                            ),
                          );
                        },
                        child: Text("Log In", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(screenHeight * 0.06),
                          backgroundColor: Color(0xFFF7941D),
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const signin(),
                            ),
                          );
                        },
                        child: Text("Sign in to another account", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(screenHeight * 0.06),
                          backgroundColor: Color.fromARGB(255, 153, 151, 148),
                          textStyle: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}