class Breathing {
  String conclusion;
  String introduction;
  String? line1;
  String? line10;
  String? line2;
  String? line3;
  String? line4;
  String? line5;
  String? line6;
  String? line7;
  String? line8;
  String? line9;
  String title;

  Breathing({
    required this.conclusion,
    required this.introduction,
    this.line1,
    this.line10,
    this.line2,
    this.line3,
    this.line4,
    this.line5,
    this.line6,
    this.line7,
    this.line8,
    this.line9,
    required this.title,
  });

  Breathing.fromJson(Map<String, dynamic> json)
      : this(
          conclusion: json['conclusion'] as String,
          introduction: json['introduction'] as String,
          line1: json['line1'] as String,
          line10: json['line10'] as String,
          line2: json['line2'] as String,
          line3: json['line3'] as String,
          line4: json['line4'] as String,
          line5: json['line5'] as String,
          line6: json['line6'] as String,
          line7: json['line7'] as String,
          line8: json['line8'] as String,
          line9: json['line9'] as String,
          title: json['title'] as String,
        );

  Breathing copyWith({
    String? conclusion,
    String? introduction,
    String? line1,
    String? line10,
    String? line2,
    String? line3,
    String? line4,
    String? line5,
    String? line6,
    String? line7,
    String? line8,
    String? line9,
    String? title,
  }) {
    return Breathing(
      conclusion: conclusion ?? this.conclusion,
      introduction: introduction ?? this.introduction,
      line1: line1 ?? this.line1,
      line10: line10 ?? this.line10,
      line2: line2 ?? this.line2,
      line3: line3 ?? this.line3,
      line4: line4 ?? this.line4,
      line5: line5 ?? this.line5,
      line6: line6 ?? this.line6,
      line7: line7 ?? this.line7,
      line8: line8 ?? this.line8,
      line9: line9 ?? this.line9,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conclusion': conclusion,
      'introduction': introduction,
      'line1': line1,
      'line10': line10,
      'line2': line2,
      'line3': line3,
      'line4': line4,
      'line5': line5,
      'line6': line6,
      'line7': line7,
      'line8': line8,
      'line9': line9,
      'title': title,
    };
  }
}

class BreathingVideo {
  String thumbnail;
  String title;
  String url;

  BreathingVideo({
    required this.thumbnail,
    required this.title,
    required this.url,
  });

  BreathingVideo.fromJson(Map<String, dynamic> json)
      : this(
          thumbnail: json['thumbnail'] as String,
          title: json['title'] as String,
          url: json['url'] as String,
        );

  BreathingVideo copyWith({
    String? thumbnail,
    String? title,
    String? url,
  }) {
    return BreathingVideo(
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      url: url ?? this.url,
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
