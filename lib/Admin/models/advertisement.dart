import 'package:cloud_firestore/cloud_firestore.dart';

class Advertisement {
  String advertisementURL;
  Timestamp? createdOn;

  Advertisement({
    required this.advertisementURL,
    this.createdOn,
  });

  Advertisement.fromJson(Map<String, dynamic> json) 
  : this(
      advertisementURL: json['advertisementURL']! as String, 
      createdOn: json['createdOn']!= null 
        ? json['createdOn'] as Timestamp? 
        : null,
  );
  
  Advertisement copyWith({
    String? advertisementURL,
    Timestamp? createdOn,
  }) {
    return Advertisement(
      advertisementURL: advertisementURL ?? this.advertisementURL,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'advertisementURL': advertisementURL,
      'createdOn': createdOn,
    };
  }
}