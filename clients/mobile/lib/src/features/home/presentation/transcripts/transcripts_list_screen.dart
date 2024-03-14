import 'package:flutter/material.dart';

class TranscriptsListScreen extends StatelessWidget {
  const TranscriptsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: Text('Minhas transcrições'),
        ),
        SliverFillRemaining(
          child: Center(
            child: Text('Sem transcrições. Envie um áudio para transcrever.'),
          ),
        ),
      ],
    );
  }
}
