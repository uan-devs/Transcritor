import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/routes/app_router.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/onboarding/presentation/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  bool get _isLastPage => _pageIndex == onboardingSlides.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingController = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _pageIndex = value;
                  });
                },
                itemCount: onboardingSlides.length,
                itemBuilder: (context, index) {
                  return onboardingSlides[index];
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < onboardingSlides.length; i++)
                  if (i == _pageIndex)
                    const DotIndicator(
                      isActive: true,
                      onPressed: null,
                    )
                  else
                    DotIndicator(
                      isActive: false,
                      onPressed: () {
                        _pageController.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: Row(
                mainAxisAlignment: _isLastPage
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!_isLastPage)
                    TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          onboardingSlides.length - 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Skip'),
                    ),
                  Visibility(
                    visible: !_isLastPage,
                    replacement: ElevatedButton(
                      onPressed: () {
                        onboardingController.setOnboardingCompleted();
                        context.pushReplacementNamed(AppRoute.login.name);
                      },
                      child: const Text('Get Started'),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, required this.isActive, this.onPressed});

  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: isActive ? 12 : 8,
        width: isActive ? 12 : 8,
        decoration: BoxDecoration(
          color: isActive ? MyColors.green : MyColors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

const List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    title: 'Explore Transcrições Precisas',
    description:
        'Bem-vindo ao Ango Speech To Text, onde a precisão na transcrição é a nossa prioridade. Transforme áudio em texto com confiança e eficiência.',
    image: 'assets/images/onboarding-img-04.jpg',
  ),
  OnboardingSlide(
    title: 'Sugestões de Correção',
    description:
        'Participe na melhoria contínua! Oferecemos a opção de enviar sugestões de correção para aprimorar a precisão das transcrições.',
    image: 'assets/images/onboarding-img-03.jpg',
  ),
  OnboardingSlide(
    title: 'Tradução Simples e Rápida',
    description:
        'Traduza as suas transcrições para diferentes idiomas com facilidade e rapidez',
    image: 'assets/images/translate-image.jpg',
  ),
  OnboardingSlide(
    title: 'Transcrição em Tempo Real',
    description:
        'Experimente a magia da transcrição em tempo real com o Ango Speech To Text. Veja suas palavras ganharem vida instantaneamente à medida que você fala.',
    image: 'assets/images/onboarding-img-05.jpg',
  ),
];

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          height: 400,
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
