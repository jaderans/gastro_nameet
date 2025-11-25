import 'package:flutter/material.dart';
import 'package:gastro_nameet/components/profile_button.dart';
import 'package:gastro_nameet/database/database_helper.dart';
import 'package:gastro_nameet/components/bookmark_comments_nav.dart';
import 'package:gastro_nameet/pages/maps/food.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  late Future<List<Map<String, dynamic>>> _bookmarksFuture;

  String _selectedSort = "Name (A-Z)"; // sorting option

  @override
  void initState() {
    super.initState();
    _refreshBookmarks();
  }

  void _refreshBookmarks() {
    setState(() {
      _bookmarksFuture = DBHelper.instance.getAllBookmarks();
    });
  }

  void _deleteBookmark(int bmId, int index) async {
    await DBHelper.instance.deleteBookmark(bmId);
    _refreshBookmarks();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bookmark deleted')),
    );
  }

  // SORT FUNCTION
  List<Map<String, dynamic>> _sortBookmarks(List<Map<String, dynamic>> list) {
    switch (_selectedSort) {
      case "Name (A-Z)":
        list.sort((a, b) =>
            (a['BM_PLACE_NAME'] ?? '').compareTo(b['BM_PLACE_NAME'] ?? ''));
        break;

      case "Name (Z-A)":
        list.sort((a, b) =>
            (b['BM_PLACE_NAME'] ?? '').compareTo(a['BM_PLACE_NAME'] ?? ''));
        break;

      case "Rating (High → Low)":
        list.sort((a, b) =>
            (b['BM_RATING'] ?? 0).compareTo(a['BM_RATING'] ?? 0));
        break;

      case "Date (Newest)":
        try {
          list.sort((a, b) => DateTime.parse(b['BM_DATE'])
              .compareTo(DateTime.parse(a['BM_DATE'])));
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
        title: Row(children: [
          Icon(Icons.bookmark_rounded, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Activities',
            style: TextStyle(
              fontFamily: 'Talina',
              color: Colors.white,
            ),
          ),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfileButton(),
          )
        ],
      ),

      body: Column(
        children: [
          // Comments button and Sort dropdown always visible
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0, bottom: 12.0),
            child: Row(
              children: [
                Expanded(child: BookmarkCommentsButton()),
                SizedBox(width: 12),
                // SORT DROPDOWN
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
                        "Name (A-Z)",
                        "Name (Z-A)",
                        "Rating (High → Low)",
                        "Date (Newest)",
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
          
          // Bookmark list
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _bookmarksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No bookmarks'));
                }

                final bookmarks = _sortBookmarks(List<Map<String, dynamic>>.from(snapshot.data!));

                return ListView.builder(
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('View on Map?'),
                              content: Text(
                                  'Do you want to view "${bookmark['BM_PLACE_NAME']}" on the map?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Direct navigation using MaterialPageRoute
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
                        },
                        title: Text(
                          bookmark['BM_PLACE_NAME'] ?? 'Untitled',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              bookmark['BM_ADDRESS'] ?? 'No Address',
                              style: TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                if (bookmark['BM_RATING'] != null)
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 16, color: Colors.amber),
                                      SizedBox(width: 4),
                                      Text('${bookmark['BM_RATING']}'),
                                      SizedBox(width: 16),
                                    ],
                                  ),
                                if (bookmark['BM_DATE'] != null)
                                  Text(
                                    bookmark['BM_DATE'].toString().split(' ')[0],
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Lat: ${bookmark['BM_LAT']?.toStringAsFixed(4) ?? 'N/A'}, '
                              'Lng: ${bookmark['BM_LNG']?.toStringAsFixed(4) ?? 'N/A'}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        leading: Icon(Icons.bookmark_rounded,
                            color: Color(0xFFFFA726)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Bookmark?'),
                                content: Text(
                                    'Are you sure you want to delete this bookmark?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteBookmark(bookmark['BM_ID'], index);
                                    },
                                    child: Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
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
}