import 'package:flutter/material.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_form_status_bar.dart';

class SignupPasswordForm extends StatefulWidget {
  const SignupPasswordForm({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  State<SignupPasswordForm> createState() => _SignupPasswordFormState();
}

class _SignupPasswordFormState extends State<SignupPasswordForm>
    with AutomaticKeepAliveClientMixin<SignupPasswordForm> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Image.asset(
              'assets/images/auth-img-03.jpg',
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
                  'Criação de senha',
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
                  currentIndex: 2,
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
                      TextFormField(
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: MyColors.green,
                          isDense: true,
                          labelText: 'Senha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: MyColors.green,
                          isDense: true,
                          labelText: 'Confirme sua senha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                            onPressed: widget.onContinue,
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
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
