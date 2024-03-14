import 'dart:convert';

class User {
  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    required this.dateOfBirth,
    required this.province,
  });

  final int id;
  final String createdAt;
  final String updatedAt;
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImage;
  final String? dateOfBirth;
  final String province;

  User copyWith({
    String? createdAt,
    String? updatedAt,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImage,
    String? dateOfBirth,
    String? province,
  }) {
    return User(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      province: province ?? this.province,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImage': profileImage,
      'dateOfBirth': dateOfBirth,
      'province': province,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String?,
      dateOfBirth: map['dateOfBirth'] as String?,
      province: map['province'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $firstName $lastName, email: $email, profileImage: $profileImage, province: $province)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.province == province;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        profileImage.hashCode ^
        province.hashCode;
  }
}
