import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';
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
  final auth = ref.watch(authTranscritorProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final path = state.uri.path;

      if (onBoardingRepository.shouldShowOnboarding()) {
        return '/onboarding';
      }

      final isLoggedIn = auth.isAuth;

      if (!isLoggedIn) {
        if (path.startsWith('/signup')) {
          return '/signup';
        }

        return '/login';
      }

      return null;
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
