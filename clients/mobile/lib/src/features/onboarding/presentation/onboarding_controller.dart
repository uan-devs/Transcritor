import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/features/onboarding/data/onboarding_repository.dart';

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);

  return OnboardingController(
    ref: ref,
    onboardingRepository: onboardingRepository,
  );
});

class OnboardingController {
  OnboardingController({required this.ref, required this.onboardingRepository});

  final ProviderRef ref;
  final AsyncValue<OnboardingRepository> onboardingRepository;

  Future<void> setOnboardingCompleted() async {
    onboardingRepository.whenData((repository) async {
      await repository.setOnboardingCompleted();
    });
  }
}
