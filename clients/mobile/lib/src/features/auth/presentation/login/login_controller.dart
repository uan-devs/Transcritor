import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';

final loginControllerProvider = Provider<LoginController>(
  (ref) {
    final auth = ref.read(authTranscritorProvider);

    return LoginController(
      auth: auth,
    );
  },
);

class LoginController {
  LoginController({required this.auth});

  final TranscritorAuth auth;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await auth.loginUser(
      email: email,
      password: password,
    );
  }
}
