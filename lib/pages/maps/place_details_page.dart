import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gastro_nameet/database/database_helper.dart';
import 'package:gastro_nameet/services/auth_service.dart';
import '../../models/place.dart';
import '../../services/places_service.dart';

class PlaceDetailsPage extends StatefulWidget {
  final Place place;

  const PlaceDetailsPage({super.key, required this.place});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  late TextEditingController _commentController;
  bool _isSaved = false;
  List<Map<String, dynamic>> _userComments = [];
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    // Load current user first, then load user-specific data
    _loadCurrentUser().then((_) async {
      await _checkIfBookmarked();
      await _loadUserComments();
    });
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUserId = await AuthService.instance.getCurrentUserId();
      setState(() {});
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _checkIfBookmarked() async {
    try {
      if (_currentUserId == null) {
        setState(() => _isSaved = false);
        return;
      }

      final bookmarks = await DBHelper.instance.getBookmarksByUser(_currentUserId!);
      final exists = bookmarks.any((bm) => bm['BM_PLACE_NAME'] == widget.place.name);
      setState(() => _isSaved = exists);
    } catch (e) {
      print('Error checking bookmark: $e');
    }
  }

  Future<void> _loadUserComments() async {
    try {
      if (_currentUserId == null) {
        setState(() {
          _userComments = [];
        });
        return;
      }

      final comments = await DBHelper.instance.getCommentsByPlaceForUser(widget.place.name, _currentUserId!);
      setState(() => _userComments = comments);
      print('Loaded ${comments.length} user comments for ${widget.place.name}');
    } catch (e) {
      print('Error loading user comments: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    try {
      if (_isSaved) {
        // Delete bookmark for current user
        if (_currentUserId == null) return;
        final bookmarks = await DBHelper.instance.getBookmarksByUser(_currentUserId!);
        final bookmark = bookmarks.firstWhere(
          (bm) => bm['BM_PLACE_NAME'] == widget.place.name,
          orElse: () => {},
        );

        if (bookmark.isNotEmpty) {
          await DBHelper.instance.deleteBookmark(bookmark['BM_ID']);
          setState(() {
            _isSaved = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bookmark removed')),
            );
          }
        }
      } else {
        // Save bookmark
        if (_currentUserId == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please sign in to save bookmarks')),
            );
          }
          return;
        }
        final bookmarkRow = {
          'BM_PLACE_NAME': widget.place.name,
          'BM_ADDRESS': widget.place.address,
          'BM_LAT': widget.place.latitude,
          'BM_LNG': widget.place.longitude,
          'BM_RATING': widget.place.rating,
          'BM_DATE': DateTime.now().toString(),
        };

        if (_currentUserId != null) {
          bookmarkRow['USER_ID'] = _currentUserId!;
        }

        await DBHelper.instance.insertBookmark(bookmarkRow);
        setState(() {
          _isSaved = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bookmark saved')),
          );
        }
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _openMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.place.latitude},${widget.place.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall() async {
    if (widget.place.phoneNumber != null) {
      final url = Uri.parse('tel:${widget.place.phoneNumber}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Future<void> _openWebsite() async {
    if (widget.place.website != null) {
      final url = Uri.parse(widget.place.website!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
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

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write a comment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_currentUserId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to post comments')),
        );
      }
      return;
    }

    try {
      final commentRow = {
        'REV_DATE': DateTime.now().toIso8601String(),
        'REV_DESC': _commentController.text.trim(),
        'REV_LAT': widget.place.latitude,
        'REV_LNG': widget.place.longitude,
        'REV_PLACE_NAME': widget.place.name,
      };

      if (_currentUserId != null) {
        commentRow['USER_ID'] = _currentUserId!;
      }

      final result = await DBHelper.instance.insertComment(commentRow);

      print('Comment saved with ID: $result');
      print('Place: ${widget.place.name}, Comment: ${_commentController.text.trim()}');

      // Reload user comments
      await _loadUserComments();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment posted successfully!'),
            backgroundColor: Color(0xFFF7941D),
          ),
        );
        _commentController.clear();
      }
    } catch (e) {
      print('Error saving comment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error posting comment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteUserComment(int revId) async {
    try {
      await DBHelper.instance.deleteComment(revId);
      await _loadUserComments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted')),
        );
      }
    } catch (e) {
      print('Error deleting comment: $e');
    }
  }

  void _showEditCommentDialog(Map<String, dynamic> comment) {
    final TextEditingController editController = TextEditingController(
      text: comment['REV_DESC'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Comment'),
        content: TextField(
          controller: editController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Edit your comment...',
            border: OutlineInputBorder(),
          ),
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
              await _loadUserComments();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Comment updated')),
              );
            },
            child: Text('Save', style: TextStyle(color: Color(0xFFF7941D))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
        backgroundColor: const Color(0xFFF7941D),
        actions: [
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal Scrollable Photos
            if (widget.place.photos != null && widget.place.photos!.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.place.photos!.length,
                  itemBuilder: (context, index) {
                    final photo = widget.place.photos![index];
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.network(
                        photo.getPhotoUrl(PlacesService.apiKey, maxWidth: 800),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, size: 80),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place Name
                  Text(
                    widget.place.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Rating
                  if (widget.place.rating != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.place.rating}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          if (widget.place.reviewCount != null)
                            Text(
                              '(${widget.place.reviewCount} reviews)',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),

                  // Open Status
                  if (widget.place.isOpenNow != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: widget.place.isOpenNow! ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.place.isOpenNow! ? 'Open Now' : 'Closed',
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.place.isOpenNow! ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  const Divider(),

                  // Address
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on, color: Color(0xFFF7941D)),
                    title: const Text('Address'),
                    subtitle: Text(widget.place.address),
                  ),

                  // Phone Number
                  if (widget.place.phoneNumber != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone, color: Color(0xFFF7941D)),
                      title: const Text('Phone'),
                      subtitle: Text(widget.place.phoneNumber!),
                      onTap: _makePhoneCall,
                    )
                  else
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone, color: Color(0xFFF7941D)),
                      title: const Text('Phone'),
                      subtitle: const Text('Not available'),
                    ),

                  // Website
                  if (widget.place.website != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language, color: Color(0xFFF7941D)),
                      title: const Text('Website'),
                      subtitle: Text(
                        widget.place.website!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: _openWebsite,
                    )
                  else
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language, color: Color(0xFFF7941D)),
                      title: const Text('Website'),
                      subtitle: const Text('Not available'),
                    ),

                  const SizedBox(height: 24),

                  // Reviews Section (from API)
                  const Text(
                    'Google Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (widget.place.reviews != null && widget.place.reviews!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.place.reviews!.length,
                      itemBuilder: (context, index) {
                        final review = widget.place.reviews![index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: review.authorPhotoUrl != null
                                          ? NetworkImage(review.authorPhotoUrl!)
                                          : null,
                                      child: review.authorPhotoUrl == null
                                          ? const Icon(Icons.person)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  review.authorName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Icon(Icons.verified, 
                                                color: Colors.blue, 
                                                size: 16),
                                              SizedBox(width: 4),
                                              Text('Google',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              ...List.generate(
                                                5,
                                                (i) => Icon(
                                                  i < review.rating
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review.text,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No Google reviews yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // User Comments Section (from Database)
                  Row(
                    children: [
                      const Text(
                        'User Comments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFFF7941D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_userComments.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_userComments.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _userComments.length,
                      itemBuilder: (context, index) {
                        final comment = _userComments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: Colors.orange.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Color(0xFFF7941D),
                                      child: const Icon(Icons.person, color: Colors.white),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                (comment['USER_NAME'] as String?) ?? 'User #${comment['USER_ID']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.badge, 
                                                color: Color(0xFFF7941D), 
                                                size: 16),
                                              SizedBox(width: 4),
                                              Text('Local',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _formatDate(comment['REV_DATE']),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Edit and Delete buttons for user's own comments
                                    if (_currentUserId != null && comment['USER_ID'] == _currentUserId) // Check if it's current user's comment
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, size: 18, color: Colors.blue),
                                            onPressed: () => _showEditCommentDialog(comment),
                                            padding: EdgeInsets.all(4),
                                            constraints: BoxConstraints(),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, size: 18, color: Colors.red),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Delete Comment?'),
                                                  content: Text('Are you sure you want to delete this comment?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _deleteUserComment(comment['REV_ID']);
                                                      },
                                                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            padding: EdgeInsets.all(4),
                                            constraints: BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    comment['REV_DESC'] ?? '',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No user comments yet. Be the first to comment!',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Comment Box Section
                  const Text(
                    'Leave a Comment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts about this place...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFF7941D),
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addComment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF7941D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Post Comment'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _toggleBookmark,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSaved
                              ? const Color(0xFFF7941D)
                              : Colors.grey[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        child: Icon(
                          _isSaved ? Icons.bookmark : Icons.bookmark_border,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}