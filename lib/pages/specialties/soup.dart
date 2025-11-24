import 'package:flutter/material.dart';
import 'package:gastro_nameet/database/database_helper.dart';
import 'package:gastro_nameet/components/food_modal.dart';

class spsoup extends StatefulWidget {
  const spsoup({super.key});

  @override
  State<spsoup> createState() => _spsoupState();
}

class _spsoupState extends State<spsoup> {
  List<Map<String, dynamic>> soupItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSoupItems();
  }

  Future<void> loadSoupItems() async {
    try {
      final db = await DBHelper.instance.database;

      // Query to get soup items (CATEG_ID 5 based on your data)
      final result = await db.query(
        'SPECIALTY',
        where: 'CATEG_ID = ?',
        whereArgs: [5],
      );

      setState(() {
        soupItems = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading soup items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Color(0xFFFFA726),
        title: Text(
          'Soup',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFFFA726)))
          : soupItems.isEmpty
              ? Center(
                  child: Text(
                    'No soup items found',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: soupItems.length,
                    itemBuilder: (context, index) {
                      final item = soupItems[index];
                      return FoodGridItem(
                        spId: item['SP_ID'],
                        imagePath: item['SP_IMG_URL'] ?? '',
                        name: item['SP_NAME'] ?? 'Unknown',
                        description: item['SP_DESCRIPTION'] ?? '',
                      );
                    },
                  ),
                ),
    );
  }
}

class FoodGridItem extends StatelessWidget {
  final int spId;
  final String imagePath;
  final String name;
  final String description;

  const FoodGridItem({
    Key? key,
    required this.spId,
    required this.imagePath,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => FoodModal(spId: spId),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 113, 101, 89).withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Color(0xFFE0E0E0),
                            child: Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Color(0xFFFFA726),
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Color(0xFFE0E0E0),
                            child: Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Color(0xFFFFA726),
                            ),
                          );
                        },
                      ),
              ),
            ),
            // Content section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Color(0xFF666666),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'see more',
                          style: TextStyle(
                            color: Color(0xFFFFA726),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Color(0xFFFFA726),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}