import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> signup() async {
    final signupNotifier = ref.read(signupStateNotifierProvider.notifier);

    await auth.signupUser(
      name: signupNotifier.name,
      email: signupNotifier.email,
      password: signupNotifier.password,
      province: signupNotifier.province,
      phone: signupNotifier.phone,
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
        state.phone.isNotEmpty &&
        state.password.isNotEmpty &&
        state.otp.isNotEmpty;
  }

  Map<String, String> get data => {
        'name': '${state.name} ${state.surname}',
        'email': state.email,
        'phone': state.phone,
        'password': state.password,
        'otp': state.otp,
      };

  String get name => '${state.name} ${state.surname}';
  String get email => state.email;
  String get phone => state.phone;
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

  void setContactInfo({required String email, required String phone}) {
    state.email = email;
    state.phone = phone;
  }

  void setPassword(String password) {
    state.password = password;
  }

  void setOTP(String otp) {
    state.otp = otp;
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
  String phone = '';
  String password = '';
  String otp = '';
}
