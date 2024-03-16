import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/routes/app_router.dart';
import 'package:transcritor/src/common/widgets/adptative_widgets.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';

final signupStateNotifierProvider =
    NotifierProvider<SignupStateNotifier, SignupState>(
  () {
    return SignupStateNotifier();
  },
);

final signupControllerProvider = Provider<SignupController>(
  (ref) {
    final auth = ref.read(authTranscritorProvider);

    return SignupController(
      auth: auth,
      ref: ref,
    );
  },
);

class SignupController {
  SignupController({required this.auth, required this.ref});

  final TranscritorAuth auth;
  final ProviderRef ref;

  Future<void> signup(BuildContext context) async {
    final signupNotifier = ref.read(signupStateNotifierProvider.notifier);

    final result = await auth.signUp(
      firstName: signupNotifier.name,
      lastName: signupNotifier.surname,
      email: signupNotifier.email,
      password: signupNotifier.password,
      province: signupNotifier.province,
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
                      child: const Text('Ok')),
                ],
              );
            },
          );
        }
      },
      (success) {
        if (context.mounted) {
          context.goNamed(AppRoutes.home.name);
        }
      },
    );
  }
}

class SignupStateNotifier extends Notifier<SignupState> {
  @override
  SignupState build() {
    return SignupState();
  }

  bool get isDataValid {
    return state.name.isNotEmpty &&
        state.surname.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty;
  }

  Map<String, String> get data => {
        'name': state.name,
        'surname': state.surname,
        'email': state.email,
        'password': state.password,
      };

  String get name => state.name;

  String get surname => state.surname;

  String get email => state.email;

  String get province => state.province;

  String get password => state.password;

  void setBasicInfo({
    required String name,
    required String surname,
    required String province,
  }) {
    state.name = name;
    state.surname = surname;
    state.province = province;
  }

  void setContactInfo({required String email}) {
    state.email = email;
  }

  void setPassword(String password) {
    state.password = password;
  }

  void reset() {
    state = SignupState();
  }
}

class SignupState {
  String name = '';
  String surname = '';
  String email = '';
  String province = '';
  String password = '';
}
