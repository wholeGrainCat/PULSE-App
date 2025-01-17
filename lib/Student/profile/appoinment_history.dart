import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/Student/appoinment/appoinment_model.dart';
//import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:student/components/app_colour.dart'; // Import AppColors

class AppointmentHistory extends StatelessWidget {
  const AppointmentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the userId from FirebaseAuth
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Appointment History'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: userId) // Filter appointments by userId
            .orderBy('createdAt', descending: true) // Order by creation date
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              Appointment appointment = Appointment.fromFirestore(doc);

              // Convert Timestamp to DateTime if needed
              DateTime createdAt = appointment.createdAt.toDate();

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: AppColors.pri_purple),
                            const SizedBox(width: 8),
                            Text(
                              'Date: ${appointment.date}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black), // Black text color
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'Location: ${appointment.location}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black), // Black text color
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.orange),
                            const SizedBox(width: 8),
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  'Counsellor: ${appointment.counsellor}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black), // Black text color
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.purple),
                            const SizedBox(width: 8),
                            Text(
                              'Time: ${appointment.time}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black), // Black text color
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Created at: ${createdAt.toLocal().toString()}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black), // Black text color
                        ),
                      ],
                    ),
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
