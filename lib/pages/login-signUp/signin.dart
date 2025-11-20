import 'package:flutter/material.dart';
import 'package:gastro_nameet/layouts/main_bottom_nav_bar.dart';
import 'package:gastro_nameet/pages/home/startscreen.dart';
import 'package:gastro_nameet/database/database_helper.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                      SizedBox(height: screenHeight * 0.08),
                      Image(
                        image: AssetImage('assets/images/batchoy_welcome.png'),
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                      ),
                      SizedBox(height: screenHeight * 0.02),
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
                          'SIGN UP',
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
                        'Press Sign Up to continue',
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
                              controller: _nameController,
                              obscureText: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                  horizontal: 10,
                                ),
                                hintText: "Name",
                                labelText: "Name",
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
                      SizedBox(height: screenHeight * 0.015),
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
                      SizedBox(height: screenHeight * 0.015),
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
                        onPressed: () async {
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          if (name.isEmpty || email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please fill all fields")),
                            );
                            return;
                          }

                          // Check for duplicate username
                          bool usernameExists = await DBHelper.instance.usernameExists(name);
                          if (usernameExists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Username already exists!")),
                            );
                            return;
                          }

                          // Check for duplicate email
                          bool emailExists = await DBHelper.instance.emailExists(email);
                          if (emailExists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Email already exists!")),
                            );
                            return;
                          }

                          final data = {
                            'USER_NAME': name,
                            'USER_EMAIL': email,
                            'USER_PASSWORD': password,
                          };

                          try {
                            await DBHelper.instance.insertUser(data);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Account created successfully!")),
                            );

                            // Clear navigation stack and go to MainNavigation
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MainNavigation()),
                              (route) => false, // Remove all previous routes
                            );

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error occurred: $e")),
                            );
                          }
                        },
                        child: Text("Sign up", style: TextStyle(color: Colors.white)),
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
                              builder: (context) => const start(),
                            ),
                          );
                        },
                        child: Text("< Go Back", style: TextStyle(color: Colors.white)),
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