import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_controller.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_form_status_bar.dart';
import 'package:validatorless/validatorless.dart';

class SignupPasswordForm extends ConsumerStatefulWidget {
  const SignupPasswordForm({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  ConsumerState<SignupPasswordForm> createState() => _SignupPasswordFormState();
}

class _SignupPasswordFormState extends ConsumerState<SignupPasswordForm>
    with AutomaticKeepAliveClientMixin<SignupPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  bool get _isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final signupStateNotifier = ref.read(signupStateNotifierProvider.notifier);

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
                  indexCount: 3,
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
                child: Visibility(
                  visible: !isLoading,
                  replacement: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          onFieldSubmitted: (_) => setState(() {}),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          validator: Validatorless.multiple([
                            Validatorless.required('Senha é obrigatória'),
                            Validatorless.min(
                                6, 'Senha deve ter no mínimo 6 caracteres'),
                            Validatorless.regex(
                              RegExp(
                                r'^(?=.*?[0-9])(?=.*?[^\w\s]).{6,}$',
                              ),
                              'Senha deve conter 1 número e 1 caractere especial',
                            ),
                          ]),
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
                          controller: _confirmPasswordController,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          onFieldSubmitted: (_) => setState(() {}),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          validator: Validatorless.multiple([
                            Validatorless.required(
                                'Confirmação de senha é obrigatória'),
                            Validatorless.compare(
                              _passwordController,
                              'Senhas não conferem',
                            ),
                          ]),
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
                              onPressed: _isFormValid
                                  ? () async {
                                signupStateNotifier
                                    .setPassword(_passwordController.text);

                                setState(() => isLoading = true);

                                await ref
                                    .read(signupControllerProvider)
                                    .signup(context);

                                setState(() => isLoading = false);
                              }
                                  : null,
                              child: const Text('Criar conta'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
