import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/Student/appoinment/appointment_new.dart';
import 'package:student/components/bottom_navigation.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;
  String errorMessage = '';
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    // Don't update state if widget is disposed
    if (!mounted) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        // Check mounted state again after async operation
        if (!mounted) return;

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
                        'counsellor': doc['counsellor'] ?? 'N/A',
                        'appointmentDate': doc['appointmentDate'] ?? 'N/A',
                        'location': doc['location'] ?? 'N/A',
                        'time': doc['time'] ?? 'N/A',
                        'status': doc['status'] ?? 'Pending',
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
      // Check mounted state before showing error
      if (!mounted) return;

      setState(() {
        errorMessage = "Error fetching appointments: $e";
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  // Get color based on appointment status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void navigateTo(String page) {
    print("Navigating to $page");
    // Handle other navigation cases
    if (page == 'Resource') {
      Navigator.pushNamed(context, '/resource');
    } else if (page == 'Dashboard') {
      Navigator.pushNamed(context, '/studentdashboard');
    } else if (page == 'Chat') {
      Navigator.pushNamed(context, '/chat');
    } else if (page == 'Profile') {
      Navigator.pushNamed(context, '/profile');
    }
  }

  Future<void> checkMoodStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Retrieve the last logged date and mood status
      String? lastLoggedDate = prefs.getString('lastLoggedDate_$userId');
      DateTime today = DateTime.now();
      String todayString = "${today.year}-${today.month}-${today.day}";

      // Check if the last logged date matches today's date
      bool hasLoggedMood = (lastLoggedDate == todayString);
      print("User ID: $userId");
      print("Last Logged Date: $lastLoggedDate");
      print("Has logged mood today: $hasLoggedMood");

      if (hasLoggedMood) {
        // Navigate to the mood done page (only once)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/mooddonecheckin');
        });
      } else {
        // Navigate to the mood tracker page if not logged
        Navigator.pushReplacementNamed(context, '/moodtracker');
      }
    }
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "Date: ${appointment['appointmentDate']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Time
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.purple),
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
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Location: ${appointment['location']}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Counsellor
            Row(
              children: [
                const Icon(Icons.person, color: Colors.orange),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      "Counsellor: ${appointment['counsellor']}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Status section moved here
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: getStatusColor(appointment['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    appointment['status'].toLowerCase() == 'Approved'
                        ? Icons.check_circle
                        : appointment['status'].toLowerCase() == 'Cancelled'
                            ? Icons.cancel
                            : Icons.pending,
                    color: getStatusColor(appointment['status']),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Status: ${appointment['status'].toUpperCase()}",
                    style: TextStyle(
                      color: getStatusColor(appointment['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Appointments",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              navigateTo('Resource');
              break;
            case 1:
              checkMoodStatus();
              break;
            case 2:
              navigateTo('Dashboard');
              break;
            case 3:
              navigateTo('Chat');
              break;
            case 4:
              navigateTo('Profile');
              break;
          }
        },
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
    );
  }
}
