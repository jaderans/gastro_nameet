import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place.dart';
import '../services/places_service.dart';

class PlaceDetailsPage extends StatelessWidget {
  final Place place;

  const PlaceDetailsPage({super.key, required this.place});

  Future<void> _openMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall() async {
    if (place.phoneNumber != null) {
      final url = Uri.parse('tel:${place.phoneNumber}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Future<void> _openWebsite() async {
    if (place.website != null) {
      final url = Uri.parse(place.website!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        backgroundColor: const Color(0xFFF7941D),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place Photo
            if (place.photoReference != null)
              Image.network(
                PlacesService().getPhotoUrl(place.photoReference!),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 80, color: Colors.grey),
                  );
                },
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
                    place.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Rating
                  if (place.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${place.rating}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),

                  // Open Status
                  if (place.isOpenNow != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: place.isOpenNow! ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.isOpenNow! ? 'Open Now' : 'Closed',
                          style: TextStyle(
                            fontSize: 16,
                            color: place.isOpenNow! ? Colors.green : Colors.red,
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
                    subtitle: Text(place.address),
                  ),

                  // Phone Number
                  if (place.phoneNumber != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone, color: Color(0xFFF7941D)),
                      title: const Text('Phone'),
                      subtitle: Text(place.phoneNumber!),
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
                  if (place.website != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language, color: Color(0xFFF7941D)),
                      title: const Text('Website'),
                      subtitle: Text(
                        place.website!,
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

                  // Action Buttons
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton.icon(
                  //         onPressed: _openMaps,
                  //         icon: const Icon(Icons.directions),
                  //         label: const Text('Get Directions'),
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: const Color(0xFFF7941D),
                  //           foregroundColor: Colors.white,
                  //           padding: const EdgeInsets.symmetric(vertical: 12),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}