import 'package:http/http.dart' as http;
import 'dart:convert';

class Review {
  final String authorName;
  final String text;
  final int rating;
  final DateTime time;
  final String? authorPhotoUrl;
  final String? language;

  Review({
    required this.authorName,
    required this.text,
    required this.rating,
    required this.time,
    this.authorPhotoUrl,
    this.language,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json['author_name'] ?? 'Anonymous',
      text: json['text'] ?? '',
      rating: json['rating'] ?? 0,
      time: DateTime.fromMillisecondsSinceEpoch(
        (json['time'] ?? 0) * 1000,
      ),
      authorPhotoUrl: json['profile_photo_url'],
      language: json['language'],
    );
  }
}

class Photo {
  final String photoReference;
  final int width;
  final int height;
  final List<String> attributions;

  Photo({
    required this.photoReference,
    required this.width,
    required this.height,
    required this.attributions,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      photoReference: json['photo_reference'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      attributions: json['html_attributions'] != null
          ? List<String>.from(json['html_attributions'])
          : [],
    );
  }

  String getPhotoUrl(String apiKey, {int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$apiKey';
  }
}

class Place {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? rating;
  final List<Photo>? photos;
  final bool? isOpenNow;
  final String? phoneNumber;
  final String? website;
  final List<String>? types;
  final List<Review>? reviews;
  final int? reviewCount;

  Place({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.photos,
    this.isOpenNow,
    this.phoneNumber,
    this.website,
    this.types,
    this.reviews,
    this.reviewCount,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    
    return Place(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      address: json['vicinity'] ?? json['formatted_address'] ?? 'No address',
      latitude: location['lat']?.toDouble() ?? 0.0,
      longitude: location['lng']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble(),
      photos: json['photos'] != null
          ? (json['photos'] as List)
              .map((photo) => Photo.fromJson(photo))
              .toList()
          : null,
      isOpenNow: json['opening_hours']?['open_now'],
      phoneNumber: json['formatted_phone_number'],
      website: json['website'],
      types: json['types'] != null ? List<String>.from(json['types']) : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((review) => Review.fromJson(review))
              .toList()
          : null,
      reviewCount: json['user_ratings_total'],
    );
  }
}

// Usage example with http package

Future<Place> fetchPlaceWithReviews(String placeId, String apiKey) async {
  final String url =
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&fields=place_id,name,geometry,vicinity,formatted_address,rating,'
      'photos,opening_hours,formatted_phone_number,website,types,reviews,'
      'user_ratings_total'
      '&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['result'] != null) {
        return Place.fromJson(json['result']);
      } else {
        throw Exception('Place not found');
      }
    } else {
      throw Exception('Failed to load place: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching place: $e');
  }
}

// Example usage:
// final place = await fetchPlaceWithReviews('ChIJ...', 'YOUR_API_KEY');
// 
// // Access all photos
// if (place.photos != null) {
//   for (var photo in place.photos!) {
//     String url = photo.getPhotoUrl('YOUR_API_KEY', maxWidth: 800);
//     print('Photo URL: $url');
//   }
// }
//
// // Access reviews
// print(place.reviews?.map((r) => '${r.authorName}: ${r.text}').toList());