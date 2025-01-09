class Counsellor {
  String email;
  String image;
  String name;
  String phoneNumber;

  Counsellor({
    required this.email,
    required this.image,
    required this.name,
    required this.phoneNumber
  });

  Counsellor.fromJson(Map<String, dynamic> json) 
  : this(
    email: json['email'] as String,
    image: json['image'] as String,
    name: json['name'] as String,
    phoneNumber: json['phoneNumber'] as String,
  );
  
  Counsellor copyWith({
    String? email,
    String? image,
    String? name,
    String? phoneNumber,
  }) {
    return Counsellor(
      email: email ?? this.email,
      image: image ?? this.image,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'image': image,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}