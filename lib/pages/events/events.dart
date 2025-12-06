import 'package:flutter/material.dart';
import 'package:gastro_nameet/database/database_helper.dart';
import 'package:gastro_nameet/components/profile_button.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final Color mainColor = const Color(0xFFFAAE3B);
  final Color accentColor = const Color(0xFFF7941D);
  final Color bgColor = const Color(0xFFF5F5F5);

  late Future<List<Map<String, dynamic>>> _eventsFuture;
  String _sortBy = 'date'; // 'date' or 'name'

  @override
  void initState() {
    super.initState();
    _eventsFuture = DBHelper.instance.getAllEvents();
  }

  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    List<Map<String, dynamic>> sorted = List.from(events);
    
    if (_sortBy == 'date') {
      sorted.sort((a, b) {
        final dateA = DateTime.tryParse(a['EV_DATE'] ?? '');
        final dateB = DateTime.tryParse(b['EV_DATE'] ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });
    } else if (_sortBy == 'name') {
      sorted.sort((a, b) {
        final nameA = (a['EV_NAME'] ?? '').toString().toLowerCase();
        final nameB = (b['EV_NAME'] ?? '').toString().toLowerCase();
        return nameA.compareTo(nameB);
      });
    }
    
    return sorted;
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event['EV_NAME'] ?? 'Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              if (event['EV_IMG_URL'] != null &&
                  (event['EV_IMG_URL'] as String).isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      event['EV_IMG_URL'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 80),
                        );
                      },
                    ),
                  ),
                ),
              // Description
              if (event['EV_DESCRIPTION'] != null &&
                  (event['EV_DESCRIPTION'] as String).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['EV_DESCRIPTION'],
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              // Date
              if (event['EV_DATE'] != null &&
                  (event['EV_DATE'] as String).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18, color: accentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Date: ${event['EV_DATE']}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              // Location
              if (event['EV_LOCATION'] != null &&
                  (event['EV_LOCATION'] as String).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          size: 18, color: accentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Location: ${event['EV_LOCATION']}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              // Establishment
              if (event['EV_ESTABLISHMENT'] != null &&
                  (event['EV_ESTABLISHMENT'] as String).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.store, size: 18, color: accentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'At: ${event['EV_ESTABLISHMENT']}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // /// 🥘 List of local Iloilo restaurants with details
  // final List<Map<String, String>> restaurants = [
  //   {
  //     "name": "Madge Café",
  //     "specialty": "Native coffee and bibingka",
  //     "message": "Start your morning with Iloilo’s classic brew at Madge Café!",
  //     "address": "La Paz Public Market, Iloilo City",
  //     "contact": "(033) 320-9749",
  //     "bestSeller": "Native Coffee (Kape Ilonggo)",
  //   },
  //   {
  //     "name": "Netong’s Batchoy",
  //     "specialty": "Authentic La Paz Batchoy",
  //     "message": "Craving a warm bowl? Taste Iloilo’s pride at Netong’s!",
  //     "address": "La Paz Public Market, Iloilo City",
  //     "contact": "0917-123-4567",
  //     "bestSeller": "Original La Paz Batchoy",
  //   },
  //   {
  //     "name": "Tatoy’s Manokan and Seafoods",
  //     "specialty": "Grilled Manokan and Seafood Platters",
  //     "message": "Grilled favorites by the sea — only at Tatoy’s!",
  //     "address": "Brgy. Sto. Niño Sur, Arevalo, Iloilo City",
  //     "contact": "(033) 337-1037",
  //     "bestSeller": "Grilled Manokan and Talaba",
  //   },
  //   {
  //     "name": "Kap Ising’s Pancit Molo",
  //     "specialty": "Crispy Pancit Molo",
  //     "message": "A local comfort dish with a crispy twist at Kap Ising’s!",
  //     "address": "Molo Mansion Complex, Molo, Iloilo City",
  //     "contact": "0922-888-4321",
  //     "bestSeller": "Crispy Pancit Molo",
  //   },
  //   {
  //     "name": "Breakthrough Restaurant",
  //     "specialty": "Fresh seafood platter",
  //     "message": "Fresh seafood by the beach — savor it at Breakthrough!",
  //     "address": "Villa Beach, Sto. Niño Sur, Arevalo, Iloilo City",
  //     "contact": "(033) 336-5360",
  //     "bestSeller": "Seafood Platter and Grilled Fish",
  //   },
  // ];

  // final List<Map<String, String>> notifications = [];

  @override
  // void initState() {
  //   super.initState();
  //   tz.initializeTimeZones();
  //   // _initializeNotifications();
  //   // _scheduleDailyNotification();
  // }

  // Future<void> _initializeNotifications() async {
  //   const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const initSettings = InitializationSettings(android: androidInit);

  //   await _notificationsPlugin.initialize(
  //     initSettings,
  //     onDidReceiveNotificationResponse: (response) {
  //       final payload = response.payload;
  //       if (payload != null) {
  //         _openRestaurant(payload);
  //       }
  //     },
  //   );
  // }

  /// ⏰ Schedules a daily 8:00 AM restaurant highlight
  // Future<void> _scheduleDailyNotification() async {
  //   const androidDetails = AndroidNotificationDetails(
  //     'daily_restaurant_channel',
  //     'Daily Iloilo Restaurant Highlight',
  //     channelDescription: 'Shows a featured local restaurant daily at 8 AM',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const details = NotificationDetails(android: androidDetails);

  //   final random = Random();
  //   final restaurant = restaurants[random.nextInt(restaurants.length)];

  //   final now = tz.TZDateTime.now(tz.local);
  //   var scheduleTime = tz.TZDateTime(
  //     tz.local,
  //     now.year,
  //     now.month,
  //     now.day,
  //     8, // 8:00 AM
  //     0,
  //   );

  //   if (now.isAfter(scheduleTime)) {
  //     scheduleTime = scheduleTime.add(const Duration(days: 1));
  //   }

  //   await _notificationsPlugin.zonedSchedule(
  //     0,
  //     restaurant["name"],
  //     "${restaurant["message"]} Tap to see details.",
  //     scheduleTime,
  //     details,
  //     payload: restaurant["name"],
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );

  //   setState(() {
  //     notifications.insert(0, {
  //       "title": restaurant["name"]!,
  //       "subtitle": restaurant["message"]!,
  //       "specialty": restaurant["specialty"]!,
  //       "address": restaurant["address"]!,
  //       "contact": restaurant["contact"]!,
  //       "bestSeller": restaurant["bestSeller"]!,
  //       "date":
  //           "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
  //     });
  //   });
  // }

  // void _openRestaurant(String restaurantName) {
  //   final restaurant = restaurants.firstWhere(
  //     (r) => r["name"] == restaurantName,
  //     orElse: () => {},
  //   );

  //   if (restaurant.isEmpty) return;

  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(restaurant["name"]!),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("📍 Address: ${restaurant["address"]}"),
  //           const SizedBox(height: 4),
  //           Text("📞 Contact: ${restaurant["contact"]}"),
  //           const SizedBox(height: 4),
  //           Text("⭐ Best Seller: ${restaurant["bestSeller"]}"),
  //           const SizedBox(height: 4),
  //           Text("🍽 Specialty: ${restaurant["specialty"]}"),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Close"),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text('Opening ${restaurant["name"]} on map...'),
  //               ),
  //             );

  //           },
  //           child: Text("View on Map", style: TextStyle(color: accentColor)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.event, color: mainColor),
            const SizedBox(width: 8),
            Text(
              'Events',
              style: TextStyle(
                fontFamily: 'Talina',
                color: accentColor,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: _sortBy == 'date' ? accentColor : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Date',
                      style: TextStyle(
                        color: _sortBy == 'date' ? accentColor : Colors.black,
                        fontWeight: _sortBy == 'date' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'name',
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_by_alpha,
                      size: 18,
                      color: _sortBy == 'name' ? accentColor : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by Name',
                      style: TextStyle(
                        color: _sortBy == 'name' ? accentColor : Colors.black,
                        fontWeight: _sortBy == 'name' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.sort, color: accentColor),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF7941D),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 80, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error loading events:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }

          final events = _sortEvents(snapshot.data ?? []);
          print('🎯 Events page received ${events.length} events (sorted by: $_sortBy)');

          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No events available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return GestureDetector(
                onTap: () => _showEventDetails(event),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Image
                      if (event['EV_IMG_URL'] != null &&
                          (event['EV_IMG_URL'] as String).isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            color: Colors.grey[300],
                            child: Image.network(
                              event['EV_IMG_URL'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: Colors.grey[500],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [mainColor, accentColor],
                              ),
                            ),
                            child: Icon(
                              Icons.event,
                              size: 80,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      // Event Details
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Name
                            Text(
                              event['EV_NAME'] ?? 'Event',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Date if available
                            if (event['EV_DATE'] != null &&
                                (event['EV_DATE'] as String).isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 16, color: accentColor),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        event['EV_DATE'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Location if available
                            if (event['EV_LOCATION'] != null &&
                                (event['EV_LOCATION'] as String).isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 16, color: accentColor),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        event['EV_LOCATION'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Establishment if available
                            if (event['EV_ESTABLISHMENT'] != null &&
                                (event['EV_ESTABLISHMENT'] as String).isNotEmpty)
                              Row(
                                children: [
                                  Icon(Icons.store,
                                      size: 16, color: accentColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      event['EV_ESTABLISHMENT'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
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
