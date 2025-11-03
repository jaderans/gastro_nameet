import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  
  final Completer<GoogleMapController> _controller = Completer(); 
  
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.728854141969126, 122.55696874742404), // iloilo city
    zoom: 10.4746,
  );

  final LatLngBounds _iloiloBounds = LatLngBounds(
    southwest: LatLng(10.67, 122.53),
    northeast: LatLng(10.854227, 122.662436), //this langlat is temporary. Para ma dala lang akon lugar sa Balabag
    
  ); // top-right corner



  @override
  Widget build(BuildContext context) {
    return Scaffold( // Add this line to use your custom AppBar
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
          ),
            
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 184, 184, 184), 
                      blurRadius: 15, 
                      offset: const Offset(0, 0),
                        // X and Y offset
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(top: 600, right: 20),
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    final GoogleMapController controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
                  },
                  child: const Icon(Icons.restart_alt),
                ),
                
                SizedBox(
                  height: 10,
                ),
                
                FloatingActionButton(
                  onPressed: () async {
                    final GoogleMapController controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
                  },
                  child: const Icon(Icons.my_location),
                ),
              ],
              
            ),
            
          ),
          
          DraggableScrollableSheet(
            initialChildSize: 0.1,   // panel height when minimized
            minChildSize: 0.1,       // minimum height
            maxChildSize: 0.7,       // maximum height when dragged up
            builder: (context, scrollController){
              return Container(
                decoration: BoxDecoration(
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
                        'Food Places in Iloilo City',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.restaurant),
                      title: Text('Restaurant A'),
                      subtitle: Text('Famous for local cuisine'),
                    ),
                    ListTile(
                      leading: Icon(Icons.fastfood),
                      title: Text('Fast Food B'),
                      subtitle: Text('Quick bites and snacks'),
                    ),
                    ListTile(
                      leading: Icon(Icons.local_cafe),
                      title: Text('Cafe C'),
                      subtitle: Text('Best coffee in town'),
                    ),
                    // Add more ListTiles as needed
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