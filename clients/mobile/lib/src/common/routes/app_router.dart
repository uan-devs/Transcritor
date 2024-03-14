import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/routes/go_router_refresh_stream.dart';
import 'package:transcritor/src/common/routes/scaffold_with_nested_navigation.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';
import 'package:transcritor/src/features/auth/presentation/login/login_screen.dart';
import 'package:transcritor/src/features/auth/presentation/signup/signup_screen.dart';
import 'package:transcritor/src/features/home/presentation/home_screen.dart';
import 'package:transcritor/src/features/onboarding/data/onboarding_repository.dart';
import 'package:transcritor/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:transcritor/src/features/settings/settings_screen.dart';
import 'package:transcritor/src/features/settings/user/user_profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _listNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

enum AppRoutes {
  onboarding,
  home,
  settings,
  userProfile,
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
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final path = state.uri.path;

      if (onBoardingRepository.shouldShowOnboarding()) {
        return '/onboarding';
      }

      if (auth.user == null) {
        await auth.autoLogin();
      }

      final isLoggedIn = auth.user != null;

      if (isLoggedIn) {
        if (path == '/login' || path == '/signup') {
          return '/home';
        }
      } else {
        if (path != '/login' && path != '/signup') {
          return '/login';
        }
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(auth.onAuthStateChanged()),
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoutes.signup.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignupScreen(),
        ),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _listNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoutes.home.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                name: AppRoutes.settings.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'profile',
                    name: AppRoutes.userProfile.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: UserProfileScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
