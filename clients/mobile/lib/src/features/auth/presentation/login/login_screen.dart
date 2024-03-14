import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/routes/app_router.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/auth/presentation/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  bool get _isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Seja bem-vindo(a)',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Image.asset(
                'assets/images/auth-img-06.jpg',
                height: 300,
                width: double.infinity,
                fit: BoxFit.fill,
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
                            controller: _emailController,
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                            onFieldSubmitted: (_) => setState(() {}),
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
                          TextFormField(
                            controller: _passwordController,
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                            onFieldSubmitted: (_) => setState(() {}),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: Validatorless.required('Senha obrigatória'),
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
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              text: 'Não tem uma conta? ',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pushNamed(AppRoutes.signup.name);
                                    },
                                  text: 'Cadastre-se',
                                  style: const TextStyle(
                                    color: MyColors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: _isFormValid ? () async {
                                  setState(() => isLoading = true);

                                  await ref.read(loginControllerProvider).login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context,
                                  );

                                  setState(() => isLoading = false);
                                } : null,
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
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
}
