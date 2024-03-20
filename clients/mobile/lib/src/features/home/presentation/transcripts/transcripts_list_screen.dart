import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:faker/faker.dart';

class TranscriptsListScreen extends StatelessWidget {
  const TranscriptsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transcriptionMockList = List.generate(
      10,
      (index) => Transcription(
        id: index.toString(),
        createdAt: DateTime.now()
            .subtract(Duration(hours: Random().nextInt(300)))
            .toIso8601String(),
        text: faker.lorem.sentence(),
        language: 'pt-BR',
        multimedia: Multimedia(
          name: '${faker.person.name()}.wav',
        ),
      ),
    );

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          elevation: 0,
          title: Text('Minhas transcrições'),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: transcriptionMockList.length,
            (context, index) {
              final e = transcriptionMockList[index];
              final date = DateTime.parse(e.createdAt);
              final hourPassed = DateTime.now().difference(date).inHours;
              final dayPassed = DateTime.now().difference(date).inDays;
              final monthPassed = DateTime.now().difference(date).inDays ~/ 30;

              final createdAt = hourPassed == 0
                  ? 'Há pouco tempo'
                  : hourPassed < 24
                      ? 'Há $hourPassed horas'
                      : dayPassed < 30
                          ? 'Há $dayPassed dias'
                          : 'Há $monthPassed meses';

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    e.multimedia!.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Text(
                    createdAt,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  leading: const Icon(Icons.lyrics),
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
      ],
    );
  }
}
