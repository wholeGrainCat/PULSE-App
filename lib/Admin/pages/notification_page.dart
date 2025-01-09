import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample Notification Data
    final notifications = [
      {
        "title": "New Appointment Booking",
        "description":
            "User John Doe booked an appointment for a consultation at 3 PM. Please confirm the availability.",
        "time": "5 mins ago",
        "icon": "assets/icons/appointment.png",
        "color": const Color(0xFFD9F65C), // Light green
      },
      {
        "title": "New Peer Support Message",
        "description":
            "Anonymous user sent a message in peer support. Please check the latest updates.",
        "time": "10 mins ago",
        "icon": "assets/icons/chat.png",
        "color": const Color(0xFFAF96F5), // Light purple
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                      color: Colors.black, fontSize: 25, fontFamily: 'Roboto'),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Container(
                      width: double.infinity, // Full width of the screen
                      margin: const EdgeInsets.only(
                          bottom: 20), // Spacing between notifications
                      padding: const EdgeInsets.all(
                          20), // Padding inside the container
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50, // Adjust outer circle width
                            height: 50, // Adjust outer circle height
                            decoration: BoxDecoration(
                              color: notification['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  8), // Adjust image padding
                              child: Image.asset(
                                notification['icon'] as String,
                                fit: BoxFit.contain,
                                width: 40, // Adjust image width
                                height: 40, // Adjust image height
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 15), // Spacing between icon and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 15, // Title font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        8), // Space between title and description
                                Text(
                                  notification['description'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        8), // Space between description and time
                                Text(
                                  notification['time'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
