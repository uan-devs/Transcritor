import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:transcritor/src/common/themes/dark_theme.dart';
import 'package:transcritor/src/features/onboarding/presentation/onboarding_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme(),
      home: const OnboardingScreen(),
    );
  }
}
