import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String counsellor;
  final String date;
  final String time;
  final String location;
  final String status;
  final String userId;
  final Timestamp createdAt;

  Appointment({
    required this.counsellor,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.userId,
    required this.createdAt,
  });

  // Factory method to create an Appointment from Firestore data
  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Appointment(
      counsellor: data['counsellor'] ?? '',
      date: data['appointmentDate'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
