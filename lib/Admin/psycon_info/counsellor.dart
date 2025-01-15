class Counsellor {
  final String name;
  final String email;
  final String phone;
  final String imageUrl;

  Counsellor({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
  });

  factory Counsellor.fromJson(Map<String, dynamic> json) {
    return Counsellor(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }
}
