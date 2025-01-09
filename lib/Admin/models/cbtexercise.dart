class Cbtexercise {
  String number;
  String title;
  String url;

  Cbtexercise({
    required this.number,
    required this.title,
    required this.url
  });

  Cbtexercise.fromJson(Map<String, dynamic> json) 
  : this(
      number: json['number']! as String,
      title: json['title']! as String, 
      url: json['url']! as String,
  );
  
  Cbtexercise copyWith({
    String? number,
    String? title,
    String? url,
  }) {
    return Cbtexercise(
      number: number ?? this.number,
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'url': url,
    };
  }
}

class CbtVideo {
  final String thumbnail;
  final String title;
  final String url;

  CbtVideo({required this.thumbnail, required this.title, required this.url});

  factory CbtVideo.fromJson(Map<String, dynamic> json) {
    return CbtVideo(
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'title': title,
      'url': url,
    };
  }
}

