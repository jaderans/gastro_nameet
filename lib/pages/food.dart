import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gastro_nameet/components/profile_button.dart';
import 'package:gastro_nameet/models/place.dart';
import 'package:gastro_nameet/services/places_service.dart';
import 'package:gastro_nameet/pages/place_details_page.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  final PlacesService _placesService = PlacesService();
  
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.728854141969126, 122.55696874742404),
    zoom: 10.4746,
  );

  final LatLngBounds _iloiloBounds = LatLngBounds(
    southwest: const LatLng(10.67, 122.53),
    northeast: const LatLng(10.854227, 122.662436),
  );

  Set<Marker> markers = {};
  List<Place> searchResults = [];
  bool isSearching = false;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _determinePosition();
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled. Please enable them.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied. Please enable them in app settings.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        markers.clear();
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      final lat = currentPosition?.latitude ?? 10.728854141969126;
      final lng = currentPosition?.longitude ?? 122.55696874742404;

      final places = await _placesService.searchPlaces(
        query: query,
        latitude: lat,
        longitude: lng,
        radius: 10000,
      );

      setState(() {
        searchResults = places;
        _updateMapMarkers(places);
        isSearching = false;
      });

      if (places.isNotEmpty) {
        _fitMapToMarkers(places);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No places found')),
          );
        }
      }
    } catch (e) {
      setState(() {
        isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _updateMapMarkers(List<Place> places) {
    markers.clear();
    
    for (var place in places) {
      markers.add(
        Marker(
          markerId: MarkerId(place.placeId),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.address,
          ),
          onTap: () => _onMarkerTapped(place),
        ),
      );
    }
  }

  Future<void> _fitMapToMarkers(List<Place> places) async {
    if (places.isEmpty) return;

    try {
      final controller = await _controller.future;
      
      double minLat = places.first.latitude;
      double maxLat = places.first.latitude;
      double minLng = places.first.longitude;
      double maxLng = places.first.longitude;

      for (var place in places) {
        if (place.latitude < minLat) minLat = place.latitude;
        if (place.latitude > maxLat) maxLat = place.latitude;
        if (place.longitude < minLng) minLng = place.longitude;
        if (place.longitude > maxLng) maxLng = place.longitude;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } catch (e) {
      print('Error fitting map: $e');
    }
  }

  void _onMarkerTapped(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailsPage(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(13, 18),
            initialCameraPosition: _initialPosition,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            cameraTargetBounds: CameraTargetBounds(_iloiloBounds),
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: false,
            markers: markers,
          ),
            
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 209, 209, 209), 
                      blurRadius: 15, 
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for food... (e.g., batchoy)',
                          hintStyle: const TextStyle(
                            color: Color(0xFFF7941D),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0), 
                            child: Image.asset(
                              'assets/images/gastro_main.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          suffixIcon: isSearching
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF7941D),
                                      ),
                                    ),
                                  ),
                                )
                              : _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _searchPlaces('');
                                      },
                                    )
                                  : null,
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        ),
                        onSubmitted: (value) => _searchPlaces(value),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const ProfileButton(),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            right: 20,
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      final GoogleMapController controller = await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
                      setState(() {
                        markers.clear();
                        searchResults = [];
                        _searchController.clear();
                      });
                    },
                    tooltip: 'Reset camera',
                    child: const Icon(Icons.restart_alt),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      try {
                        Position position = await _determinePosition();
                    
                        final controller = await _controller.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(position.latitude, position.longitude),
                              zoom: 15,
                            ),
                          ),
                        );
                    
                        setState(() {
                          currentPosition = position;
                          markers.clear();
                          markers.add(
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position: LatLng(position.latitude, position.longitude),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue,
                              ),
                            ),
                          );
                        });
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    tooltip: 'Current Location',
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        searchResults.isEmpty
                            ? 'Search for food places'
                            : '${searchResults.length} places found',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...searchResults.map((place) => ListTile(
                      leading: const Icon(Icons.restaurant, color: Color(0xFFF7941D)),
                      title: Text(place.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.address),
                          if (place.rating != null)
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text('${place.rating}'),
                              ],
                            ),
                        ],
                      ),
                      onTap: () => _onMarkerTapped(place),
                    )),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}