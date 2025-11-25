import 'package:flutter/material.dart';
import 'package:gastro_nameet/components/profile_button.dart';
import 'package:gastro_nameet/database/database_helper.dart';
import 'package:gastro_nameet/components/bookmark_comments_nav.dart';
import 'package:gastro_nameet/pages/maps/food.dart';

class CommentsDisplay extends StatefulWidget {
  const CommentsDisplay({super.key});

  @override
  State<CommentsDisplay> createState() => _CommentsDisplayState();
}

class _CommentsDisplayState extends State<CommentsDisplay> {
  late Future<List<Map<String, dynamic>>> _commentsFuture;
  String _selectedSort = "Date (Newest)";

  @override
  void initState() {
    super.initState();
    _refreshComments();
  }

  void _refreshComments() {
    setState(() {
      _commentsFuture = DBHelper.instance.getAllComments();
    });
    
    // Debug: Print comments to console
    DBHelper.instance.getAllComments().then((comments) {
      print('Total comments: ${comments.length}');
      for (var comment in comments) {
        print('Comment: ${comment['REV_DESC']} at ${comment['REV_PLACE_NAME']}');
      }
    });
  }

  void _deleteComment(int revId) async {
    await DBHelper.instance.deleteComment(revId);
    _refreshComments();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comment deleted')),
    );
  }

  void _showEditDialog(Map<String, dynamic> comment) {
    final TextEditingController editController = TextEditingController(
      text: comment['REV_DESC'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Comment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment['REV_PLACE_NAME'] ?? 'Unknown Place',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFFFA726),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: editController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Edit your comment...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (editController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Comment cannot be empty')),
                );
                return;
              }

              await DBHelper.instance.updateComment(
                comment['REV_ID'],
                {
                  'REV_DESC': editController.text.trim(),
                  'REV_DATE': DateTime.now().toIso8601String(),
                },
              );

              Navigator.pop(context);
              _refreshComments();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Comment updated')),
              );
            },
            child: Text('Save', style: TextStyle(color: Color(0xFFFFA726))),
          ),
        ],
      ),
    );
  }

  void _showViewOnMapDialog(Map<String, dynamic> comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View on Map?'),
        content: Text(
          'Do you want to view "${comment['REV_PLACE_NAME']}" on the map?',
        ),
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
                      'searchQuery': comment['REV_PLACE_NAME'],
                      'latitude': comment['REV_LAT'],
                      'longitude': comment['REV_LNG'],
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

  List<Map<String, dynamic>> _sortComments(List<Map<String, dynamic>> list) {
    switch (_selectedSort) {
      case "Place (A-Z)":
        list.sort((a, b) =>
            (a['REV_PLACE_NAME'] ?? '').compareTo(b['REV_PLACE_NAME'] ?? ''));
        break;

      case "Place (Z-A)":
        list.sort((a, b) =>
            (b['REV_PLACE_NAME'] ?? '').compareTo(a['REV_PLACE_NAME'] ?? ''));
        break;

      case "Date (Newest)":
        try {
          list.sort((a, b) => DateTime.parse(b['REV_DATE'])
              .compareTo(DateTime.parse(a['REV_DATE'])));
        } catch (e) {}
        break;

      case "Date (Oldest)":
        try {
          list.sort((a, b) => DateTime.parse(a['REV_DATE'])
              .compareTo(DateTime.parse(b['REV_DATE'])));
        } catch (e) {}
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Color(0xFFFFA726),
        title: Row(
          children: [
            Icon(Icons.comment_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Comments',
              style: TextStyle(
                fontFamily: 'Talina',
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfileButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Navigation and Sort controls
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: Row(
              children: [
                SizedBox(width: 12),
                // Sort Dropdown
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      dropdownColor: Colors.white,
                      items: [
                        "Date (Newest)",
                        "Date (Oldest)",
                        "Place (A-Z)",
                        "Place (Z-A)",
                      ].map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSort = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Comments List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add comments from the map',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final comments = _sortComments(
                  List<Map<String, dynamic>>.from(snapshot.data!),
                );

                return ListView.builder(
                  itemCount: comments.length,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _showViewOnMapDialog(comment),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Place name and actions
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Color(0xFFFFA726),
                                          size: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            comment['REV_PLACE_NAME'] ?? 'Unknown Place',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFFFFA726),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Edit button
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () => _showEditDialog(comment),
                                    padding: EdgeInsets.all(8),
                                    constraints: BoxConstraints(),
                                  ),
                                  // Delete button
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete Comment?'),
                                          content: Text(
                                            'Are you sure you want to delete this comment?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteComment(comment['REV_ID']);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    padding: EdgeInsets.all(8),
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              // Comment text
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  comment['REV_DESC'] ?? '',
                                  style: TextStyle(fontSize: 14, height: 1.5),
                                ),
                              ),

                              SizedBox(height: 12),

                              // Date and coordinates
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    _formatDate(comment['REV_DATE']),
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Lat: ${comment['REV_LAT']?.toStringAsFixed(4) ?? 'N/A'}, '
                                    'Lng: ${comment['REV_LNG']?.toStringAsFixed(4) ?? 'N/A'}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateStr.split(' ')[0];
    }
  }
}