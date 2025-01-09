import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String counselor;
  final String date;
  final String time;
  final String location;
  final String userId;
  final Timestamp createdAt;

  Appointment({
    required this.counselor,
    required this.date,
    required this.time,
    required this.location,
    required this.userId,
    required this.createdAt,
  });

  // Factory method to create an Appointment from Firestore data
  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Appointment(
      counselor: data['counselor'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
