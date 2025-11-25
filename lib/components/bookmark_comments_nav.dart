import 'package:flutter/material.dart';
import 'package:gastro_nameet/pages/activities/comments_display.dart';
// import 'comments_page.dart';

class BookmarkCommentsButton extends StatefulWidget {
  const BookmarkCommentsButton({super.key});

  @override
  State<BookmarkCommentsButton> createState() => _BookmarkCommentsButtonState();
}

class _BookmarkCommentsButtonState extends State<BookmarkCommentsButton> {
  bool isOnBookmarks = true; // true = showing "Bookmark", false = "Comments"

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // optional, controls button width
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate to Comments page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommentsDisplay(), // replace with your page
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 255, 183, 68),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        icon: Icon(
          Icons.comment_rounded,
          size: 20,
          color: Colors.white,
        ),
        label: Text(
          'Comments',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
