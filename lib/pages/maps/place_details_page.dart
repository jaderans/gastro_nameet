import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gastro_nameet/database/database_helper.dart';
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

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _checkIfBookmarked();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _checkIfBookmarked() async {
    try {
      final bookmarks = await DBHelper.instance.getAllBookmarks();
      final exists = bookmarks.any((bm) => bm['BM_PLACE_NAME'] == widget.place.name);
      setState(() {
        _isSaved = exists;
      });
    } catch (e) {
      print('Error checking bookmark: $e');
    }
  }

  Future<void> _toggleBookmark() async {
    try {
      if (_isSaved) {
        // Delete bookmark
        final bookmarks = await DBHelper.instance.getAllBookmarks();
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
        await DBHelper.instance.insertBookmark({
          'BM_PLACE_NAME': widget.place.name,
          'BM_ADDRESS': widget.place.address,
          'BM_LAT': widget.place.latitude,
          'BM_LNG': widget.place.longitude,
          'BM_RATING': widget.place.rating,
          'BM_DATE': DateTime.now().toString(),
        });
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

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment added: ${_commentController.text}'),
          backgroundColor: const Color(0xFFF7941D),
        ),
      );
      _commentController.clear();
    }
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

                  // Reviews Section
                  const Text(
                    'Reviews',
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
                                          Text(
                                            review.authorName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
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
                        'No reviews yet',
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