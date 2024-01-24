import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingRepositoryProvider =
    FutureProvider<OnboardingRepository>((ref) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  return OnboardingRepository(sharedPreferences: sharedPreferences);
});

class OnboardingRepository {
  OnboardingRepository({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _shouldShowOnboardingKey = 'shouldShowOnboarding';

  bool shouldShowOnboarding() {
    return sharedPreferences.getBool(_shouldShowOnboardingKey) ?? true;
  }

  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(_shouldShowOnboardingKey, false);
  }
}
