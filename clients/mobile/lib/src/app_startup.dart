import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/features/onboarding/data/onboarding_repository.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  await appStartup(ref);
});

Future<void> appStartup(FutureProviderRef ref) async {
  await ref.watch(onboardingRepositoryProvider.future);
}

class AppStartup extends ConsumerWidget {
  const AppStartup({super.key, required this.onLoaded});

  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);

    return appStartupState.when(
      data: (data) {
        return onLoaded(context);
      },
      loading: () {
        return const AppStartupLoadingWidget();
      },
      error: (error, stackTrace) {
        return AppStartupErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(onboardingRepositoryProvider);
          },
        );
      },
    );
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget(
      {super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: Theme.of(context).textTheme.headlineSmall),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
