import 'package:flutter/material.dart';
import 'package:student/pages/appointment_new.dart';

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({super.key});

  // Mock appointment data (replace with actual data later)
  final List<Map<String, String>> appointments = [
    {
      "Counselor": "Pn Fauziah Bee binti Mohd Salleh",
      "Date": "2024-12-20",
      "Time": "10:00 AM",
      "Location": "Counseling Room 101", // Location added
      "Status": "Pending",
      "cancellationReason": ""
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Appointments",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Header Section - Enhanced with gradient and icon
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9747FF),
                  Color(0xFF7C5DFF)
                ], // Purple gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Appointments",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Track and manage your scheduled appointments.",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Appointment List or Empty State
          Expanded(
            child: appointments.isEmpty
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
          // Make New Appointment Button with app purple color
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
                  backgroundColor: const Color(0xFF9747FF), // Purple color
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/icons/empty.png',
              height: 150), // Replace with your image asset
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
      BuildContext context, Map<String, String> appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          appointment['Counselor'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: ${appointment['Location']}"),
            Text("Date: ${appointment['Date']}"),
            Text("Time: ${appointment['Time']}"),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(appointment['Status'] ?? 'Pending'),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () => _showCancellationDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Status Chip Widget
  Widget _buildStatusChip(String status) {
    Color color = status == "Pending" ? Colors.orange : Colors.green;
    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  // Cancellation Dialog
  void _showCancellationDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Appointment"),
        content: TextField(
          controller: reasonController,
          decoration:
              const InputDecoration(labelText: "Reason for cancellation"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              print('Cancellation Reason: ${reasonController.text}');
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
