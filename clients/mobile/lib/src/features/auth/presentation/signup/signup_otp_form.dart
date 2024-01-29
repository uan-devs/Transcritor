import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_form_status_bar.dart';

class SignupOTPForm extends StatefulWidget {
  const SignupOTPForm({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  State<SignupOTPForm> createState() => _SignupOTPFormState();
}

class _SignupOTPFormState extends State<SignupOTPForm>
    with AutomaticKeepAliveClientMixin<SignupOTPForm> {
  final Map<int, String> _otp = {};

  bool get _isFormValid => _otp.length == 6;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    debugPrint(
        'isFormValid: $_isFormValid | OTP: $_otp | Length: ${_otp.length}');

    return SafeArea(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Image.asset(
              'assets/images/auth-img-05.jpg',
              height: 300,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                child: const Text(
                  'Verificação OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: const Center(
                child: SignupFormStatusBar(
                  indexCount: 4,
                  currentIndex: 3,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Form(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) {
                            return SizedBox(
                              height: 60,
                              width: MediaQuery.sizeOf(context).width * .10,
                              child: TextFormField(
                                key: ValueKey(index),
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    setState(() {
                                      _otp[index] = value;
                                    });
                                    FocusScope.of(context).nextFocus();
                                  } else {
                                    setState(() {
                                      _otp.remove(index);
                                    });
                                  }
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                textInputAction:
                                    index == 5 ? TextInputAction.done : null,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                enabled: true,
                                style: const TextStyle(color: MyColors.green),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(.2),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: widget.onBack,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isFormValid ? () {} : null,
                            child: const Text(
                              'Verificar',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
