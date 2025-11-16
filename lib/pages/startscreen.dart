import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gastro_nameet/pages/signin.dart';
import 'package:gastro_nameet/pages/loginstart.dart';

class start extends StatefulWidget {
  const start({super.key});

  @override
  State<start> createState() => _startState();
}

class _startState extends State<start> {
  late PageController _pageController;
  late Timer _timer;
  late List<Widget> _pages;

  final List<String> imagePaths = [
    'assets/images/Slide 1.png',
    'assets/images/Slide 2.png',
    'assets/images/Slide 3.png',
    'assets/images/Slide 4.png',
    'assets/images/Slide 5.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pages = List.generate(imagePaths.length,
        (index) => ImagePlaceholder(imagePath: imagePaths[index]));
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int currentPage = _pageController.page?.round() ?? 0;
        int nextPage = currentPage + 1;

        if (nextPage >= imagePaths.length) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/startscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content - Using SafeArea and flexible layout
          SafeArea(
            child: Column(
              children: [
                // Spacer to push content based on screen height
                SizedBox(height: screenHeight * 0.15),

                // Main content area - flexible
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          top: screenHeight * 0.01,
                          bottom: screenHeight * 0.005,
                        ),
                        child: Text(
                          'This is Gastro Nameet',
                          style: TextStyle(
                            fontFamily: 'Talina',
                            height: 1,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFAAD3B),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 60, left: 60),
                        child: Text(
                          'Do you crave something authentic?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            height: 1,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 166, 166, 166),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.35,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: imagePaths.length,
                          itemBuilder: (context, index) {
                            return _pages[index];
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Buttons at the bottom - fixed position
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.015,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const loginstart(),
                        ),
                      );
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
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
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.08,
                    right: screenWidth * 0.08,
                    bottom: screenHeight * 0.03,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const signin(),
                        ),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(screenHeight * 0.06),
                      backgroundColor: Color.fromARGB(255, 239, 117, 17),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final String? imagePath;
  const ImagePlaceholder({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath!,
      fit: BoxFit.cover,
    );
  }
}