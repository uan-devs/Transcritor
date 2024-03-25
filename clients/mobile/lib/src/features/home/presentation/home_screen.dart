import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/features/auth/data/transcritor_auth.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcripts_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authTranscritorProvider);

    return Scaffold(
      body: Builder(
        builder: (context) {
          switch (auth.user != null) {
            case true:
              return const TranscriptsListScreen();
            case false:
              return const CircularProgressIndicator.adaptive();
          }
        },
      ),
    );
  }
}
