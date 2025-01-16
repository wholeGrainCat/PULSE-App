import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String name;
  final String date;
  final String time;
  final String location;
  final String counselor;
  final String status;
  final String createdAt;

  Appointment({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.counselor,
    required this.status,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['appointmentDate'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      counselor: json['counselor'] as String,
      status: json['status'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate().toIso8601String(),
    );
  }
}
