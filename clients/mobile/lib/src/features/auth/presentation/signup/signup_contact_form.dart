import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_form_status_bar.dart';
import 'package:validatorless/validatorless.dart';

class SignupContactForm extends StatefulWidget {
  const SignupContactForm({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  State<SignupContactForm> createState() => _SignupContactFormState();
}

class _SignupContactFormState extends State<SignupContactForm>
    with AutomaticKeepAliveClientMixin<SignupContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool get _isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Image.asset(
                'assets/images/auth-img-02.jpg',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: const Text(
                    'Informações de contacto',
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
                  child: SignupFormStatusBar(indexCount: 4, currentIndex: 1),
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
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validatorless.multiple([
                            Validatorless.required('Email obrigatório'),
                            Validatorless.email('Email inválido'),
                          ]),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            prefixIconColor: MyColors.green,
                            isDense: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        IntlPhoneField(
                          controller: _phoneController,
                          countries: [
                            countries.firstWhere((c) => c.code == 'AO'),
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          languageCode: "pt",
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
                              onPressed:
                                  _isFormValid ? widget.onContinue : null,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
