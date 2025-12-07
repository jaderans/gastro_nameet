import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gastro_nameet/components/profile_button.dart';
import 'package:gastro_nameet/components/horizontal_food_list.dart';
import 'package:gastro_nameet/pages/specialties/breakfast.dart';
import 'package:gastro_nameet/pages/specialties/lunch.dart';
import 'package:gastro_nameet/pages/specialties/dinner.dart';
import 'package:gastro_nameet/pages/specialties/snacks.dart';
import 'package:gastro_nameet/pages/specialties/soup.dart';
import 'package:gastro_nameet/pages/specialties/dessert.dart';
import 'package:gastro_nameet/database/database_helper.dart';
import 'package:gastro_nameet/services/auth_service.dart';
import 'package:gastro_nameet/components/food_modal.dart';
import 'package:gastro_nameet/pages/maps/food.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? todaySpecial;
  List<Map<String, dynamic>> bookmarks = [];
  int? currentUserId;
  PageController _bookmarkPageController = PageController();
  Timer? _autoScrollTimer;
  int _currentBookmarkPage = 0;

  @override
  void initState() {
    super.initState();
    _loadTodaySpecial();
    _loadUserBookmarks();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _bookmarkPageController.dispose();
    super.dispose();
  }

  // Load Today's Special (changes daily)
  Future<void> _loadTodaySpecial() async {
    try {
      final db = await DBHelper.instance.database;
      final allSpecialties = await db.query('SPECIALTY');

      if (allSpecialties.isNotEmpty) {
        // Use day of year to determine which specialty to show
        final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
        final selectedIndex = dayOfYear % allSpecialties.length;

        setState(() {
          todaySpecial = allSpecialties[selectedIndex];
        });
      }
    } catch (e) {
      print('Error loading today\'s special: $e');
    }
  }

  // Load user's bookmarks
  Future<void> _loadUserBookmarks() async {
    try {
      currentUserId = await AuthService.instance.getCurrentUserId();

      if (currentUserId != null) {
        final userBookmarks = await DBHelper.instance.getBookmarksByUser(currentUserId!);
        setState(() {
          bookmarks = userBookmarks;
        });

        // Start auto-scroll timer if there are bookmarks
        if (bookmarks.length > 1) {
          _startAutoScroll();
        }
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }

  // Auto-scroll bookmarks
  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_bookmarkPageController.hasClients && bookmarks.isNotEmpty) {
        int nextPage = (_currentBookmarkPage + 1) % bookmarks.length;
        _bookmarkPageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Navigate to map with location search
  void _navigateToMapWithLocation(String locationName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Food(),
        settings: RouteSettings(
          arguments: {
            'searchQuery': 'Food $locationName',
          },
        ),
      ),
    );
  }

  // Navigate to map with bookmark
  void _navigateToMapWithBookmark(Map<String, dynamic> bookmark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View on Map?'),
        content: Text('Do you want to view "${bookmark['BM_PLACE_NAME']}" on the map?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Food(),
                  settings: RouteSettings(
                    arguments: {
                      'searchQuery': bookmark['BM_PLACE_NAME'],
                      'latitude': bookmark['BM_LAT'],
                      'longitude': bookmark['BM_LNG'],
                    },
                  ),
                ),
              );
            },
            child: Text('Yes', style: TextStyle(color: Color(0xFFFFA726))),
          ),
        ],
      ),
    );
  }

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
              // TODAY'S SPECIAL - UPDATED TO USE DATABASE
              Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20.0, right: 20.0, left: 20.0),
              child: todaySpecial == null
                  ? Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
                    )
                  : Container(
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
                  todaySpecial!['SP_IMG_URL'] != null
                      ? Image.network(
                          todaySpecial!['SP_IMG_URL'],
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Color(0xFFE0E0E0),
                            child: Icon(Icons.restaurant, size: 60, color: Color(0xFFFFA726)),
                          ),
                        )
                      : Container(
                          color: Color(0xFFE0E0E0),
                          child: Icon(Icons.restaurant, size: 60, color: Color(0xFFFFA726)),
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
                        todaySpecial!['SP_NAME']?.toString().toUpperCase() ?? 'UNKNOWN',
                        style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF333333),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show food modal with today's special
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => FoodModal(spId: todaySpecial!['SP_ID']),
                          );
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
              // BOOKMARKS - UPDATED TO USE DATABASE WITH SLIDESHOW
              bookmarks.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 20.0, right: 20.0, left: 20.0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark_border, size: 40, color: Colors.grey[400]),
                              SizedBox(height: 8),
                              Text(
                                'No bookmarks yet',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          height: 150,
                          child: PageView.builder(
                            controller: _bookmarkPageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentBookmarkPage = index;
                              });
                            },
                            itemCount: bookmarks.length,
                            itemBuilder: (context, index) {
                              final bookmark = bookmarks[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Container(
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
                                                  (bookmark['BM_PLACE_NAME'] ?? 'Unknown').toString().toUpperCase(),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Color(0xFF333333),
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8),
                                                Expanded(
                                                  child: Text(
                                                    bookmark['BM_ADDRESS'] ?? 'No address available',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 10,
                                                      color: Color(0xFF666666),
                                                      height: 1.3,
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (bookmark['BM_RATING'] != null) ...[
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, size: 12, color: Colors.amber),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '${bookmark['BM_RATING']}',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Color(0xFF666666),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                SizedBox(height: 8),
                                                GestureDetector(
                                                  onTap: () => _navigateToMapWithBookmark(bookmark),
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
                                            child: bookmark['BM_IMG'] != null && bookmark['BM_IMG'].toString().isNotEmpty
                                                ? Image.network(
                                                    bookmark['BM_IMG'],
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                    alignment: Alignment.center,
                                                    errorBuilder: (context, error, stackTrace) => Container(
                                                      color: Color(0xFFE0E0E0),
                                                      child: Icon(Icons.restaurant, size: 40, color: Color(0xFFFFA726)),
                                                    ),
                                                  )
                                                : Container(
                                                    color: Color(0xFFE0E0E0),
                                                    child: Icon(Icons.restaurant, size: 40, color: Color(0xFFFFA726)),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (bookmarks.length > 1) ...[
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              bookmarks.length,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 3),
                                width: _currentBookmarkPage == index ? 20 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentBookmarkPage == index ? Color(0xFFFFA726) : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 20),
                      ],
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
              // PEOPLE LOVE FOOD FROM - UPDATED TO NAVIGATE TO MAP
              HorizontalFoodList(
                foodItems: [
                  FoodCardData(
                    imagePath: 'assets/images/lpz.jpg',
                    title: 'Lapaz',
                    onTap: () => _navigateToMapWithLocation('Lapaz'),
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/mandu.jpg',
                    title: 'Mandurriao',
                    onTap: () => _navigateToMapWithLocation('Mandurriao'),
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/ctyprpr.jpg',
                    title: 'Iloilo City Proper',
                    onTap: () => _navigateToMapWithLocation('Iloilo City Proper'),
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/pavia.jpg',
                    title: 'Pavia',
                    onTap: () => _navigateToMapWithLocation('Pavia'),
                  ),
                  FoodCardData(
                    imagePath: 'assets/images/villa.jpg',
                    title: 'Villa Arevalo',
                    onTap: () => _navigateToMapWithLocation('Villa Arevalo'),
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