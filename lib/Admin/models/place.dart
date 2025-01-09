import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  Timestamp? createdOn;
  String day;
  String time;

  Place({
    this.createdOn,
    required this.day,
    required this.time,
  });

  Place.fromJson(Map<String, dynamic> json) 
  : this(
    createdOn: json['createdOn']!= null 
      ? json['createdOn'] as Timestamp? 
      : null,
    day: json['day'] as String,
    time: json['time'] as String
  );
  
  Place copyWith({
    Timestamp? createdOn,
    String? day,
    String? time,
  }) {
    return Place(
      createdOn: createdOn ?? this.createdOn,
      day: day ?? this.day,
      time: time ?? this.time
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdOn': createdOn,
      'day': day,
      'time': time,
    };
  }
}