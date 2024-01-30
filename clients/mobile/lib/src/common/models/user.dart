import 'dart:convert';

class User {
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.province,
  });

  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String province;

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? province,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      province: province ?? this.province,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'province': province,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      photoUrl: map['photoUrl'] as String,
      province: map['province'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, phone: $phone, photoUrl: $photoUrl, province: $province)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.photoUrl == photoUrl &&
        other.province == province;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        photoUrl.hashCode ^
        province.hashCode;
  }
}
