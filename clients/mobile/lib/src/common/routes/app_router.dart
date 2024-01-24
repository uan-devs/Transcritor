import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/features/home/presentation/home_screen.dart';
import 'package:transcritor/src/features/onboarding/data/onboarding_repository.dart';
import 'package:transcritor/src/features/onboarding/presentation/onboarding_screen.dart';

enum AppRoute {
  onboarding,
  home,
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
      } else {
        return '/home';
      }
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
    ],
  );
}
