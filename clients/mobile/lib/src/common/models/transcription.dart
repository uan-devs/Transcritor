import 'dart:convert';

class Transcription {
  final String id;
  final String text;
  final String createdAt;
  final String language;
  Multimedia? multimedia;
  List<Word>? words;

  Transcription({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.language,
    this.multimedia,
    this.words = const [],
  });

  Transcription copyWith({
    String? id,
    String? text,
    String? createdAt,
    String? language,
    Multimedia? multimedia,
    List<Word>? words,
  }) {
    return Transcription(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      language: language ?? this.language,
      multimedia: multimedia ?? this.multimedia,
      words: words ?? this.words,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt,
      'language': language,
      'multimedia': multimedia?.toMap(),
      'words': words?.map((x) => x.toMap()).toList(),
    };
  }

  factory Transcription.fromMap(Map<String, dynamic> map) {
    return Transcription(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: map['createdAt'] as String,
      language: map['language'] as String,
      multimedia: map['multimedia'] != null
          ? Multimedia.fromMap(map['multimedia'] as Map<String, dynamic>)
          : null,
      words: List<Word>.from(
        (map['words'] as List<int>).map<Word>(
          (x) => Word.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transcription.fromJson(String source) =>
      Transcription.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transcription(id: $id, text: $text, createdAt: $createdAt, language: $language, multimedia: $multimedia, words: $words)';
  }
}

class Word {
  final String word;
  final String initialTime;
  final String finalTime;

  Word({
    required this.word,
    required this.initialTime,
    required this.finalTime,
  });

  Word copyWith({
    String? word,
    String? initialTime,
    String? finalTime,
  }) {
    return Word(
      word: word ?? this.word,
      initialTime: initialTime ?? this.initialTime,
      finalTime: finalTime ?? this.finalTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'word': word,
      'initialTime': initialTime,
      'finalTime': finalTime,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] as String,
      initialTime: map['initialTime'] as String,
      finalTime: map['finalTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) =>
      Word.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Word(word: $word, initialTime: $initialTime, finalTime: $finalTime)';

  @override
  bool operator ==(covariant Word other) {
    if (identical(this, other)) return true;

    return other.word == word &&
        other.initialTime == initialTime &&
        other.finalTime == finalTime;
  }

  @override
  int get hashCode => word.hashCode ^ initialTime.hashCode ^ finalTime.hashCode;
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
      url: map['url'] as String,
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
