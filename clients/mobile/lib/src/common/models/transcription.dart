import 'dart:convert';

class Transcription {
  final int id;
  final String text;
  final String createdAt;
  final String language;
  Multimedia? multimedia;
  List<Sentence>? sentences;

  Transcription({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.language,
    this.multimedia,
    this.sentences = const [],
  });

  Transcription copyWith({
    int? id,
    String? text,
    String? createdAt,
    String? language,
    Multimedia? multimedia,
    List<Sentence>? sentences,
  }) {
    return Transcription(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      language: language ?? this.language,
      multimedia: multimedia ?? this.multimedia,
      sentences: sentences ?? this.sentences,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt,
      'language': language,
      'multimedia': multimedia?.toMap(),
      'sentences': sentences?.map((x) => x.toMap()).toList(),
    };
  }

  factory Transcription.fromMap(Map<String, dynamic> map) {
    return Transcription(
      id: map['id'] as int,
      text: map['text'] as String,
      createdAt: map['createdAt'] as String,
      language: map['language'] as String,
      multimedia: map['multimedia'] != null
          ? Multimedia.fromMap(map['multimedia'] as Map<String, dynamic>)
          : null,
      sentences: map['sentences'] != null
          ? List<Sentence>.from(
              (map['sentences'] as List).map((x) => Sentence.fromMap(x as Map<String, dynamic>)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transcription.fromJson(String source) =>
      Transcription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transcription(id: $id, text: $text, createdAt: $createdAt, language: $language, multimedia: $multimedia, sentences: $sentences)';
  }
}

class Sentence {
  final String sentence;
  final String initialTime;
  final String finalTime;

  Sentence({
    required this.sentence,
    required this.initialTime,
    required this.finalTime,
  });

  Sentence copyWith({
    String? sentence,
    String? initialTime,
    String? finalTime,
  }) {
    return Sentence(
      sentence: sentence ?? this.sentence,
      initialTime: initialTime ?? this.initialTime,
      finalTime: finalTime ?? this.finalTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sentence': sentence,
      'initialTime': initialTime,
      'finalTime': finalTime,
    };
  }

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      sentence: map['sentence'] as String,
      initialTime: map['initialTime'] as String,
      finalTime: map['finalTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sentence.fromJson(String source) =>
      Sentence.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'sentence(sentence: $sentence, initialTime: $initialTime, finalTime: $finalTime)';

  @override
  bool operator ==(covariant Sentence other) {
    if (identical(this, other)) return true;

    return other.sentence == sentence &&
        other.initialTime == initialTime &&
        other.finalTime == finalTime;
  }

  @override
  int get hashCode => sentence.hashCode ^ initialTime.hashCode ^ finalTime.hashCode;
}

class Multimedia {
  final String name;
  String? url;

  Multimedia({
    required this.name,
    this.url,
  });

  Multimedia copyWith({
    String? name,
    String? url,
  }) {
    return Multimedia(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
    };
  }

  factory Multimedia.fromMap(Map<String, dynamic> map) {
    return Multimedia(
      name: map['name'] as String,
      url: map['url'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Multimedia.fromJson(String source) =>
      Multimedia.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Multimedia(name: $name, url: $url)';

  @override
  bool operator ==(covariant Multimedia other) {
    if (identical(this, other)) return true;

    return other.name == name && other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
