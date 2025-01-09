import 'package:flutter/material.dart';

class AppointmentHistoryPage extends StatelessWidget {
  const AppointmentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/background.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Page Content
          Column(
            children: [
              AppBar(
                title: const Text('Appointment History'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Appointment History Content",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
