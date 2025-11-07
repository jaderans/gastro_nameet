import 'package:flutter/material.dart';
import 'package:gastro_nameet/layouts/main_bottom_nav_bar.dart';

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
    return Scaffold(
      body: Form(
        child: Column(
            children: [
            // Background image using Stack
            Expanded(
              child: Stack(
              children: [
                Positioned.fill(
                child: Image.asset(
                  'assets/images/login_bg.png',
                  fit: BoxFit.cover,
                ),
                ),
                SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 120, bottom: 10),
                    child: Image(
                    image: AssetImage('assets/images/batchoy_welcome.png'),
                    width: 170,
                    height: 170,
                    ),
                  ),
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
                      'LOG IN',
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
                    'Press Login to continue',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      height:1,
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
                        controller: _emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 208, 208, 208)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFFF7941D)),
                        ),
                        labelStyle: TextStyle(
                          color: hasFocus ? Color(0xFFF7941D) : null,
                        ),
                        ),
                      );
                      },
                    ),
                    ),
                  ), // TextFormField
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 25, bottom: 0),
                    child: Focus(
                    child: Builder(
                      builder: (context) {
                      final hasFocus = Focus.of(context).hasFocus;
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 208, 208, 208)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFFF7941D)),
                        ),
                        labelStyle: TextStyle(
                          color: hasFocus ? Color(0xFFF7941D) : null,
                        ),
                        ),
                      );
                      },
                    ),
                    ),
                  ), // TextFormField
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 40, bottom: 0),
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
                  ), // ElevatedButton
                  SizedBox(height: 30),
                  ],
                ),
                ),
              ],
              ),
            ),
            ],
        ), // Form
      ), // Scaffold
    );
  }
} 