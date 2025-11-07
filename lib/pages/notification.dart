import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // final FlutterLocalNotificationsPlugin _notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  final Color mainColor = const Color(0xFFFAAE3B);
  final Color accentColor = const Color(0xFFF7941D);
  final Color bgColor = const Color(0xFFF5F5F5);

  /// 🥘 List of local Iloilo restaurants with details
  final List<Map<String, String>> restaurants = [
    {
      "name": "Madge Café",
      "specialty": "Native coffee and bibingka",
      "message": "Start your morning with Iloilo’s classic brew at Madge Café!",
      "address": "La Paz Public Market, Iloilo City",
      "contact": "(033) 320-9749",
      "bestSeller": "Native Coffee (Kape Ilonggo)",
    },
    {
      "name": "Netong’s Batchoy",
      "specialty": "Authentic La Paz Batchoy",
      "message": "Craving a warm bowl? Taste Iloilo’s pride at Netong’s!",
      "address": "La Paz Public Market, Iloilo City",
      "contact": "0917-123-4567",
      "bestSeller": "Original La Paz Batchoy",
    },
    {
      "name": "Tatoy’s Manokan and Seafoods",
      "specialty": "Grilled Manokan and Seafood Platters",
      "message": "Grilled favorites by the sea — only at Tatoy’s!",
      "address": "Brgy. Sto. Niño Sur, Arevalo, Iloilo City",
      "contact": "(033) 337-1037",
      "bestSeller": "Grilled Manokan and Talaba",
    },
    {
      "name": "Kap Ising’s Pancit Molo",
      "specialty": "Crispy Pancit Molo",
      "message": "A local comfort dish with a crispy twist at Kap Ising’s!",
      "address": "Molo Mansion Complex, Molo, Iloilo City",
      "contact": "0922-888-4321",
      "bestSeller": "Crispy Pancit Molo",
    },
    {
      "name": "Breakthrough Restaurant",
      "specialty": "Fresh seafood platter",
      "message": "Fresh seafood by the beach — savor it at Breakthrough!",
      "address": "Villa Beach, Sto. Niño Sur, Arevalo, Iloilo City",
      "contact": "(033) 336-5360",
      "bestSeller": "Seafood Platter and Grilled Fish",
    },
  ];

  final List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    // _initializeNotifications();
    // _scheduleDailyNotification();
  }

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

  void _openRestaurant(String restaurantName) {
    final restaurant = restaurants.firstWhere(
      (r) => r["name"] == restaurantName,
      orElse: () => {},
    );

    if (restaurant.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(restaurant["name"]!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 Address: ${restaurant["address"]}"),
            const SizedBox(height: 4),
            Text("📞 Contact: ${restaurant["contact"]}"),
            const SizedBox(height: 4),
            Text("⭐ Best Seller: ${restaurant["bestSeller"]}"),
            const SizedBox(height: 4),
            Text("🍽 Specialty: ${restaurant["specialty"]}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${restaurant["name"]} on map...'),
                ),
              );

            },
            child: Text("View on Map", style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: mainColor),
            const SizedBox(width: 8),
            Text(
              'Daily Iloilo Food Highlights',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return GestureDetector(
                  onTap: () => _openRestaurant(notif["title"]!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: mainColor.withValues(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              Icon(Icons.restaurant, color: accentColor, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notif["title"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                notif["subtitle"]!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "⭐ ${notif["bestSeller"]}",
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          notif["date"]!,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
