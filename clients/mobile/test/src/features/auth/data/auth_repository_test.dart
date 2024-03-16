import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transcritor/src/features/auth/data/auth_repository.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';

void main() async {
  late ProviderContainer container;

  setUpAll(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('The repository provider should return an instance of AuthRepository',
      () {
    final repository = container.read(authTranscritorProvider);

    expect(repository, isA<AuthRepository>());
  });
}
