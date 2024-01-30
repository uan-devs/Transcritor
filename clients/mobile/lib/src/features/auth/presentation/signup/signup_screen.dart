import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_basic_info_form.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_contact_form.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_otp_form.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_password_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Registro',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            context.pop();
          },
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Page 1: Basic info
          SignupBasicInfoForm(
            onContinue: () {
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
          // Page 2: Contact info
          SignupContactForm(
            onContinue: () {
              _pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            onBack: () {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
          // Page 3: Password
          SignupPasswordForm(
            onContinue: () {
              _pageController.animateToPage(
                3,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            onBack: () {
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
          // Page 4: OTP
          SignupOTPForm(
            onContinue: () {
              _pageController.animateToPage(
                4,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            onBack: () {
              _pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}
