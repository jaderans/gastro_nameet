class Place {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? rating;
  final String? photoReference;
  final bool? isOpenNow;
  final String? phoneNumber;
  final String? website;
  final List<String>? types;

  Place({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.photoReference,
    this.isOpenNow,
    this.phoneNumber,
    this.website,
    this.types,
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
      photoReference: json['photos'] != null && json['photos'].isNotEmpty
          ? json['photos'][0]['photo_reference']
          : null,
      isOpenNow: json['opening_hours']?['open_now'],
      phoneNumber: json['formatted_phone_number'],
      website: json['website'],
      types: json['types'] != null ? List<String>.from(json['types']) : null,
    );
  }
}