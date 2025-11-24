import 'package:flutter/material.dart';
import 'package:gastro_nameet/components/profile_button.dart';
import 'package:gastro_nameet/database/database_helper.dart';

class Save extends StatefulWidget {
  const Save({super.key});

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
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
            'Save',
            style: TextStyle(
              fontFamily: 'Talina',
              color: Colors.white,
            ),
          ),
        ]),
        actions: [
          // SORT DROPDOWN
          DropdownButtonHideUnderline(
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
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSort = value!;
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfileButton(),
          )
        ],
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
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
    );
  }
}
