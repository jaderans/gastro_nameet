import 'package:flutter/material.dart';
import 'package:gastro_nameet/database/database_helper.dart';

class FoodModal extends StatefulWidget {
  final int spId;

  const FoodModal({Key? key, required this.spId}) : super(key: key);

  @override
  State<FoodModal> createState() => _FoodModalState();
}

class _FoodModalState extends State<FoodModal> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? foodData;
  List<String> categories = [];
  bool isLoading = true;
  bool isBookmarked = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    loadFoodData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadFoodData() async {
    try {
      final db = await DBHelper.instance.database;

      // Get all specialties with the same name (to handle multiple categories)
      final result = await db.query(
        'SPECIALTY',
        where: 'SP_ID = ?',
        whereArgs: [widget.spId],
      );

      if (result.isNotEmpty) {
        final food = result.first;

        // Get all categories for this food item (same name across different categories)
        final allInstancesResult = await db.query(
          'SPECIALTY',
          where: 'SP_NAME = ?',
          whereArgs: [food['SP_NAME']],
        );

        // Collect all unique category IDs for this food
        Set<int> categoryIds = {};
        for (var instance in allInstancesResult) {
          if (instance['CATEG_ID'] != null) {
            categoryIds.add(instance['CATEG_ID'] as int);
          }
        }

        // Fetch category names for all category IDs
        for (var categoryId in categoryIds) {
          final categoryResult = await db.query(
            'CATEGORY',
            where: 'CATEG_ID = ?',
            whereArgs: [categoryId],
          );

          if (categoryResult.isNotEmpty) {
            categories.add(categoryResult.first['CATEG_NAME'] as String);
          }
        }

        setState(() {
          foodData = food;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading food data: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Failed to load food details');
    }
  }

  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });

    if (isBookmarked) {
      _animationController.forward().then((_) => _animationController.reverse());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isBookmarked ? 'Added to bookmarks!' : 'Removed from bookmarks',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: isBookmarked ? Color(0xFFFFA726) : Color(0xFF666666),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _shareFood() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Share functionality coming soon!',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFFFA726),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snacks':
        return Icons.fastfood;
      case 'soup':
        return Icons.ramen_dining;
      case 'dessert':
      case 'desserts':
        return Icons.icecream;
      default:
        return Icons.local_dining;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFFFFA726),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading delicious details...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                )
              : foodData == null
                  ? _buildErrorState()
                  : Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildImageSection(),
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildTitleSection(),
                                      SizedBox(height: 16),
                                      _buildCategorySection(),
                                      SizedBox(height: 24),
                                      _buildDescriptionSection(),
                                      SizedBox(height: 24),
                                      _buildHistorySection(),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header with close and actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Color(0xFF333333)),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Close',
              ),
              Row(
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Color(0xFFFFA726) : Color(0xFF666666),
                      ),
                      onPressed: _toggleBookmark,
                      tooltip: 'Bookmark',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: Color(0xFF666666)),
                    onPressed: _shareFood,
                    tooltip: 'Share',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Hero(
      tag: 'food_${widget.spId}',
      child: Container(
        width: double.infinity,
        height: 280,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: foodData!['SP_IMG_URL'] != null &&
                      foodData!['SP_IMG_URL'].toString().isNotEmpty
                  ? (foodData!['SP_IMG_URL'].toString().startsWith('http')
                      ? Image.network(
                          foodData!['SP_IMG_URL'],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildImagePlaceholder(isLoading: true);
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        )
                      : Image.asset(
                          foodData!['SP_IMG_URL'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        ))
                  : _buildImagePlaceholder(),
            ),
            // Gradient overlay for better text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder({bool isLoading = false}) {
    return Container(
      color: Color(0xFFE0E0E0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            CircularProgressIndicator(color: Color(0xFFFFA726))
          else ...[
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Color(0xFFFFA726),
            ),
            SizedBox(height: 8),
            Text(
              'No Image Available',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      children: [
        Expanded(
          child: Text(
            foodData!['SP_NAME'] ?? 'Unknown Food',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Color(0xFF333333),
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    if (categories.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFA726).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getCategoryIcon(category), size: 14, color: Colors.white),
              SizedBox(width: 6),
              Text(
                category,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionSection() {
    final description = foodData!['SP_DESCRIPTION'];
    if (description == null || description.toString().trim().isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFFA726).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.description, color: Color(0xFFFFA726), size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Description',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            description,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    final history = foodData!['SP_HISTORY'];
    if (history == null || history.toString().trim().isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFFA726).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.history_edu, color: Color(0xFFFFA726), size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'History & Origins',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            history,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Color(0xFFE0E0E0),
            ),
            SizedBox(height: 16),
            Text(
              'Food Not Found',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sorry, we couldn\'t find the details for this dish.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back', style: TextStyle(fontFamily: 'Poppins')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFA726),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}