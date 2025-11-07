import 'package:flutter/material.dart';
import 'package:GastroNameet/layouts/main_bottom_nav_bar.dart';

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
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 25, bottom: 0),
              child: Focus(
              child: Builder(
                builder: (context) {
                final hasFocus = Focus.of(context).hasFocus;
                return TextFormField(
                  controller: _emailController,
                  obscureText: true,
                  decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 208, 208, 208)),
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
                left: 25.0, right: 25.0, top: 25, bottom: 0),
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
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 208, 208, 208)),
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
                left: 25.0, right: 25.0, top: 40, bottom: 0),
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
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                ),
              ),
              ),
            ), // ElevatedButton
          ], // Column
        ), // Form
      ), // Scaffold
    );
  }
} 