import 'package:flutter/material.dart';

class HorizontalFoodList extends StatelessWidget {
  final List<FoodCardData> foodItems;

  const HorizontalFoodList({
    super.key,
    required this.foodItems,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final item = foodItems[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < foodItems.length - 1 ? 15 : 0,
            ),
            child: FoodCard(
              imagePath: item.imagePath,
              title: item.title,
              onTap: item.onTap,
            ),
          );
        },
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String imagePath;
  final String? title;
  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.imagePath,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 198, 198, 198).withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              // Image
              Expanded(
                child: Image(
                  image: AssetImage(imagePath),
                  width: 100,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              // Optional title at bottom
              if (title != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  color: Colors.white,
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model for food card
class FoodCardData {
  final String imagePath;
  final String? title;
  final VoidCallback? onTap;

  FoodCardData({
    required this.imagePath,
    this.title,
    this.onTap,
  });
}