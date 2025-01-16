class Appointment {
  String counsellingType;
  String appointmentDate;
  String time;
  String location;
  String description;
  String email;
  String? id;
  String issue;
  String matricNumber;
  String name;
  String phoneNumber;
  String status;

  Appointment(
      {required this.counsellingType,
      required this.appointmentDate,
      required this.time,
      required this.location,
      required this.description,
      required this.email,
      this.id,
      required this.issue,
      required this.matricNumber,
      required this.name,
      required this.phoneNumber,
      required this.status});

  Appointment.fromJson(Map<String, dynamic> json)
      : this(
          counsellingType: json['counsellingType'] as String,
          appointmentDate: json['appointmentDate'] as String,
          time: json['time'] as String,
          location: json['location'] as String,
          description: json['description'] as String,
          email: json['email'] as String,
          issue: json['issue'] as String,
          matricNumber: json['matricNumber'] as String,
          name: json['fullName'] as String,
          phoneNumber: json['phoneNumber'] as String,
          status: json['status'] as String,
        );

  Appointment.fromFirestore(Map<String, dynamic> json, String id)
      : this(
          counsellingType: json['counsellingType'] as String,
          appointmentDate: json['appointmentDate'] as String,
          time: json['time'] as String,
          location: json['location'] as String,
          description: json['description'] as String,
          email: json['email'] as String,
          id: id,
          issue: json['issue'] as String,
          matricNumber: json['matricNumber'] as String,
          name: json['fullName'] as String,
          phoneNumber: json['phoneNumber'] as String,
          status: json['status'] as String,
        );

  Appointment copyWith(
      {String? counsellingType,
      String? appointmentDate,
      String? time,
      String? location,
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
      time: time ?? this.time,
      location: location ?? this.location,
      description: description ?? this.description,
      email: email ?? this.email,
      id: id ?? this.id,
      issue: issue ?? this.issue,
      matricNumber: matricsNumber ?? this.matricNumber,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counsellingType': counsellingType,
      'appointmentDate': appointmentDate,
      'time': time,
      'location': location,
      'description': description,
      'email': email,
      'issue': issue,
      'matricNumber': matricNumber,
      'fullName': name,
      'phoneNumber': phoneNumber,
      'status': status
    };
  }
}
