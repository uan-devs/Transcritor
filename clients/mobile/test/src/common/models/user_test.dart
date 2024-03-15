import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transcritor/src/common/models/user.dart';

void main() async {
  final faker = Faker();
  group('User', () {
    test('should return a valid model', () {
      final user = User(
        id: random.integer(100),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        firstName: faker.person.name(),
        email: faker.internet.email(),
        province: faker.address.city(),
        dateOfBirth: null,
        lastName: faker.person.lastName(),
        profileImage: null,
      );

      expect(user, isA<User>());
      expect(user.id, isA<int>());
      expect(user.firstName, isA<String>());
      expect(user.email, isA<String>());
      expect(user.lastName, isA<String>());
      expect(user.province, isA<String>());
      expect(user.createdAt, isA<String>());
      expect(user.updatedAt, isA<String>());
      expect(user.dateOfBirth, isNull);
      expect(user.profileImage, isNull);
      expect(user.toMap(), isA<Map<String, dynamic>>());
    });

    test('two users are equals', () {
      final user1 = User(
        id: random.integer(100),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        firstName: faker.person.name(),
        email: faker.internet.email(),
        province: faker.address.city(),
        dateOfBirth: null,
        lastName: faker.person.lastName(),
        profileImage: null,
      );

      final user2 = User(
        id: random.integer(100),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        firstName: user1.firstName,
        email: user1.email,
        province: user1.province,
        dateOfBirth: user1.dateOfBirth,
        lastName: user1.lastName,
        profileImage: user1.profileImage,
      );

      expect(user1 == user2, true);
    });

    test('user toString method', () {
      final user = User(
        id: random.integer(100),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        firstName: faker.person.name(),
        email: faker.internet.email(),
        province: faker.address.city(),
        dateOfBirth: null,
        lastName: faker.person.lastName(),
        profileImage: null,
      );

      expect(user.toString(), isA<String>());
      expect(user.toString(), contains('User'));
      expect(user.toString(), contains('name'));
      expect(user.toString(), contains('email'));
      expect(user.toString(), contains('province'));
    });
  });
}
