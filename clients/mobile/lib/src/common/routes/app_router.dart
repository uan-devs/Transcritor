import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/features/auth/presentation/login/login_screen.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:transcritor/src/features/home/presentation/home_screen.dart';
import 'package:transcritor/src/features/onboarding/data/onboarding_repository.dart';
import 'package:transcritor/src/features/onboarding/presentation/onboarding_screen.dart';

enum AppRoute {
  onboarding,
  home,
  login,
  signup,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return goRouter(ref);
});

GoRouter goRouter(ProviderRef ref) {
  final onBoardingRepository =
      ref.watch(onboardingRepositoryProvider).requireValue;

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (state, context) {
      if (onBoardingRepository.shouldShowOnboarding()) {
        return '/onboarding';
      }

      // TODO: Add logic to get the user logged in status
      const isLoggedIn = false;

      // ignore: dead_code
      if (isLoggedIn) {
        return '/home';
      }

      return '/signup';
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoute.signup.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignupScreen(),
        ),
      ),
    ],
  );
}
