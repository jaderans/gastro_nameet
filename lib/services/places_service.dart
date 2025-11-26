import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class PlacesService {
  // IMPORTANT: Replace with your actual Google API Key
  static const String apiKey = 'AIzaSyD2h3UzNlQLJEOjMRuRr4LMKHQppvusAtg';
  static const String baseUrl = 'https://maps.googleapis.com/maps/api/place';

  // Search for places near a location
  Future<List<Place>> searchPlaces({
    required String query,
    required double latitude,
    required double longitude,
    int radius = 5000,
  }) async {
    final url = Uri.parse(
      '$baseUrl/nearbysearch/json?location=$latitude,$longitude&radius=$radius&keyword=$query&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final List results = data['results'];
          return results.map((json) => Place.fromJson(json)).toList();
        } else if (data['status'] == 'ZERO_RESULTS') {
          return [];
        } else {
          throw Exception('Places API error: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching places: $e');
    }
  }

  // Get place details
  Future<Place> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      '$baseUrl/details/json?place_id=$placeId&fields=place_id,name,formatted_address,formatted_phone_number,website,rating,opening_hours,geometry,photos,types,reviews,user_ratings_total&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          return Place.fromJson(data['result']);
        } else {
          throw Exception('Place details error: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      throw Exception('Error getting place details: $e');
    }
  }

  // Get photo URL
  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$baseUrl/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=$apiKey';
  }
}