import 'package:cloud_firestore/cloud_firestore.dart';

class Meditation {
  String author;
  Timestamp? createdOn;
  String thumbnail;
  String title;
  String url;

  Meditation(
      {required this.author,
      this.createdOn,
      required this.thumbnail,
      required this.title,
      required this.url});

  Meditation.fromJson(Map<String, dynamic> json)
      : this(
          author: json['author']! as String,
          createdOn: json['createdOn'] != null
              ? json['createdOn'] as Timestamp?
              : null,
          title: json['title']! as String,
          thumbnail: json['thumbnail']! as String,
          url: json['url']! as String,
        );

  Meditation copyWith({
    String? author,
    Timestamp? createdOn,
    String? thumbnail,
    String? title,
    String? url,
  }) {
    return Meditation(
      author: author ?? this.author,
      createdOn: createdOn ?? this.createdOn,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'createdOn': createdOn,
      'thumbnail': thumbnail,
      'title': title,
      'url': url,
    };
  }
}
