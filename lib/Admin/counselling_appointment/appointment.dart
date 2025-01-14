import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String counsellingType;
  Timestamp appointmentDate;
  String description;
  String email;
  String? id;
  String issue;
  String matricsNumber;
  String name;
  String phoneNumber;
  String status;

  Appointment(
      {required this.counsellingType,
      required this.appointmentDate,
      required this.description,
      required this.email,
      this.id,
      required this.issue,
      required this.matricsNumber,
      required this.name,
      required this.phoneNumber,
      required this.status});

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
          counsellingType: json['counsellingType'] as String,
          appointmentDate: json['appointmentDate'] as Timestamp,
          description: json['description'] as String,
          email: json['email'] as String,
          issue: json['issue'] as String,
          matricsNumber: json['matricsNumber'] as String,
          name: json['name'] as String,
          phoneNumber: json['phoneNumber'] as String,
          status: json['status'] as String,
        );

  Appointment.fromFirestore(Map<String, dynamic> json, String id)
      : this(
          counsellingType: json['counsellingType'] as String,
          appointmentDate: json['appointmentDate'] as Timestamp,
          description: json['description'] as String,
          email: json['email'] as String,
          id: id,
          issue: json['issue'] as String,
          matricsNumber: json['matricsNumber'] as String,
          name: json['name'] as String,
          phoneNumber: json['phoneNumber'] as String,
          status: json['status'] as String,
        );

  Appointment copyWith(
      {String? counsellingType,
      Timestamp? appointmentDate,
      String? description,
      String? email,
      String? id,
      String? issue,
      String? matricsNumber,
      String? name,
      String? phoneNumber,
      String? status}) {
    return Appointment(
      counsellingType: counsellingType ?? this.counsellingType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      description: description ?? this.description,
      email: email ?? this.email,
      id: id ?? this.id,
      issue: issue ?? this.issue,
      matricsNumber: matricsNumber ?? this.matricsNumber,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counsellingType': counsellingType,
      'appointmentDate': appointmentDate,
      'description': description,
      'email': email,
      'issue': issue,
      'matricsNumber': matricsNumber,
      'name': name,
      'phoneNumber': phoneNumber,
      'status': status
    };
  }
}
