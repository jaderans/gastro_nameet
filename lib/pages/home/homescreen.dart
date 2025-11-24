import 'package:flutter/material.dart';
import 'package:gastro_nameet/components/profile_button.dart';
import 'package:gastro_nameet/components/horizontal_food_list.dart';
import 'package:gastro_nameet/pages/specialties/breakfast.dart';
import 'package:gastro_nameet/pages/specialties/lunch.dart';
import 'package:gastro_nameet/pages/specialties/dinner.dart';
import 'package:gastro_nameet/pages/specialties/snacks.dart';
import 'package:gastro_nameet/pages/specialties/soup.dart';
import 'package:gastro_nameet/pages/specialties/dessert.dart';

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
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Color(0xFFFFA726),
        title: Image(image: AssetImage('assets/images/gastro_icon2.png'), height: 35),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfileButton(),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
              padding: const EdgeInsets.only(top: 0, left: 20.0, right: 20.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                "Today's Special",
                style: TextStyle(
                  fontFamily: 'Talina',
                  height: 0,
                  fontSize: 16,
                  color: Color(0xFF333333),
                ),
                ),
              ),
              ),
              Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20.0, right: 20.0, left: 20.0),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                  color: const Color.fromARGB(255, 113, 101, 89).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                  ),
                ],
                ),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                  // Image
                  Image(
                    image: AssetImage('assets/images/Lapaz-Batchoy-Header.jpg'),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  // White label at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(
                        'BATCHOY',
                        style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF333333),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                        // Handle see more action
                        print('See more tapped');
                        },
                        child: Row(
                        children: [
                          Text(
                          'see more',
                          style: TextStyle(
                            color: Color(0xFFFFA726),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Color(0xFFFFA726),
                          ),
                        ],
                        ),
                      ),
                      ],
                    ),
                    ),
                  ),
                  ],
                ),
                ),
              ),
              ),
              SizedBox(height: 10),
              Padding(
              padding: const EdgeInsets.only(top: 0, left: 20.0, right: 20.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                "Foods You May Like",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Talina',
                  height: 0,
                  fontSize: 10,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  {'label': 'Breakfast', 'icon': Icons.free_breakfast},
                  {'label': 'Lunch', 'icon': Icons.lunch_dining},
                  {'label': 'Dinner', 'icon': Icons.dinner_dining},
                  {'label': 'Snacks', 'icon': Icons.fastfood},
                  {'label': 'Soup', 'icon': Icons.ramen_dining},
                  {'label': 'Desserts', 'icon': Icons.icecream},
                ].map((item) {
                  return InkWell(
                    onTap: () {
                      switch (item['label']) {
                        case 'Breakfast':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => spbreakfast()),
                          );
                          break;

                        case 'Lunch':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => splunch()),
                          );
                          break;

                        case 'Dinner':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => spdinner()),
                          );
                          break;

                        case 'Snacks':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => spsnacks()),
                          );
                          break;

                        case 'Soup':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => spsoup()),
                          );
                          break;

                        case 'Desserts':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => spdessert()),
                          );
                          break;
                      }
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color.fromARGB(255, 113, 101, 89).withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: 20,
                            color: Color(0xFFFFA726),
                          ),
                          SizedBox(height: 8),
                          Text(
                            item['label'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              Padding(
              padding: const EdgeInsets.only(top: 0, left: 20.0, right: 20.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                "Bookmarks",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Talina',
                  height: 0,
                  fontSize: 15,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 20.0, right: 20.0, left: 20.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 113, 101, 89).withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Row(
                      children: [
                        // Left side - Information
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "BATCHOY",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Color(0xFF666666),
                                      height: 1.3,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    print('See more tapped');
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'see more',
                                        style: TextStyle(
                                          color: Color(0xFFFFA726),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: Color(0xFFFFA726),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Right side - Image
                        Expanded(
                          flex: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            child: Image(
                              image: AssetImage('assets/images/Lapaz-Batchoy-Header.jpg'),
                              height: 150,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
                  Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                    "People love food from",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Talina',
                      height: 0,
                      fontSize: 15,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              HorizontalFoodList(
                foodItems: [
                  FoodCardData(
                    imagePath: 'assets/images/Lapaz-Batchoy-Header.jpg',
                    title: 'Batchoy',
                    onTap: () {
                      print('Batchoy tapped');
                      // Navigate to detail page
                    },
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/kbl.jpg',
                    title: 'KBL',
                    onTap: () {
                      print('KBL tapped');
                    },
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/pnctmolo.jpg',
                    title: 'Pancit Molo',
                    onTap: () {
                      print('Pancit Molo tapped');
                    },
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/inasal.jpg',
                    title: 'Inasal',
                    onTap: () {
                      print('Inasal tapped');
                    },
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/biscocho.jpg',
                    title: 'Biscocho',
                    onTap: () {
                      print('Biscocho tapped');
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
