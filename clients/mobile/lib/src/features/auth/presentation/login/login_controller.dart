import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/widgets/adptative_widgets.dart';
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
    required BuildContext context,
  }) async {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
          (exception) {
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: const Text('An error occur'),
                content: Text(exception.toString()),
                actions: [
                  AdaptiveWidgets.adaptiveAction(
                      context: context,
                      onPressed: () {
                        if (context.canPop()) context.pop();
                      },
                      child: const Text('Ok')
                  ),
                ],
              );
            },
          );
        }
      },
          (success) => null,
    );
  }
}
