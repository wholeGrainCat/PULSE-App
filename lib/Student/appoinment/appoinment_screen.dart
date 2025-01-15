import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int _currentIndex = 3;

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
            .collection('scheduled_appointments')
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
                        'counselor': doc['counselor'] ?? 'N/A',
                        'date': doc['date'] ?? 'N/A',
                        'location': doc['location'] ?? 'N/A',
                        'time': doc['time'] ?? 'N/A',
                        'status': doc['status'] ?? 'pending',
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

  // Handle navigation bar tap
  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
                  "Date: ${appointment['date']}",
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
                const Icon(Icons.person, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "Counselor: ${appointment['counselor']}",
                  style: const TextStyle(color: Colors.black),
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
                    appointment['status'].toLowerCase() == 'approved'
                        ? Icons.check_circle
                        : appointment['status'].toLowerCase() == 'cancelled'
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
            // Show counselor notes if they exist
            /*if (appointment['counselorNotes'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.note, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "Counselor Notes:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment['counselorNotes'],
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],*/
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
}
