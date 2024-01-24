import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/routes/app_router.dart';
import 'package:transcritor/src/common/themes/dark_theme.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Transcritor',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: darkTheme(),
      darkTheme: darkTheme(),
    );
  }
}
