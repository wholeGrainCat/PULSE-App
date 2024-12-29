import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/pages/appointment_new.dart';
import 'package:student/components/bottom_navigation.dart'; // Import the BottomNavigation widget

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // Store fetched appointments
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true; // To manage loading state
  String errorMessage = ''; // To store error message
  int _currentIndex =
      3; // Set default index for the 'Home' tab in BottomNavigation

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Fetch data on initialization
  }

  // Fetch appointments from Firestore
  Future<void> fetchAppointments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('scheduled_appointments')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        if (querySnapshot.docs.isEmpty) {
          setState(() {
            appointments = [];
            isLoading = false;
          });
        } else {
          final List<Map<String, dynamic>> fetchedAppointments =
              querySnapshot.docs
                  .map((doc) => {
                        'id': doc.id,
                        'counselor': doc['counselor'] ?? 'N/A',
                        'date': doc['date'] ?? 'N/A',
                        'location': doc['location'] ?? 'N/A',
                        'time': doc['time'] ?? 'N/A',
                        'createdAt': doc['createdAt'] ?? '',
                      })
                  .toList();

          setState(() {
            appointments = fetchedAppointments;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching appointments: $e";
        isLoading = false;
      });
      // Display error message using a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  // Handle navigation bar tap
  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to different pages based on index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/resource');
        break; // Add break to avoid fall-through
      case 1:
        Navigator.pushReplacementNamed(context, '/moodtracker');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/studentdashboard');
        break;
      case 3:
        Navigator.pushReplacementNamed(
            context, '/support'); // Stay on this screen or go to another page
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Appointments",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Header Section with plain text
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Track your scheduled appointments.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Appointment List or Empty State
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : appointments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return _buildAppointmentCard(context, appointment);
                        },
                      ),
          ),
          const SizedBox(height: 10),
          // Make New Appointment Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: const Text(
                  'Make New Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9747FF),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewAppointmentScreen(),
                    ),
                  ).then((_) => fetchAppointments()); // Refresh on return
                },
              ),
            ),
          ),
        ],
      ),
      // Add BottomNavigation bar here
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty.jpg', height: 150),
          const SizedBox(height: 20),
          const Text(
            "No Appointments Yet!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Schedule your first appointment now.",
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  // Appointment Card Widget
  Widget _buildAppointmentCard(
      BuildContext context, Map<String, dynamic> appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white, // White background for the card
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date with icon first and in bold
            Row(
              children: [
                const Icon(
                  Icons.date_range,
                  color: Colors.blue, // Icon color for Date
                ),
                const SizedBox(width: 8),
                Text(
                  "Date: ${appointment['date']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black, // Black text color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Added space between date and time
            // Time
            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: Colors.purple, // Icon color for Time
                ),
                const SizedBox(width: 8),
                Text(
                  "Time: ${appointment['time']}",
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.green, // Icon color for Location
                ),
                const SizedBox(width: 8),
                Text(
                  "Location: ${appointment['location']}",
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Counselor
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.orange, // Icon color for Counselor
                ),
                const SizedBox(width: 8),
                Text(
                  "Counselor: ${appointment['counselor']}",
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
