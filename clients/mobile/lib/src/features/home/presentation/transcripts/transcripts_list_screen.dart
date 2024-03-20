import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:faker/faker.dart';
import 'package:transcritor/src/features/home/data/transcripts_repository.dart';

class TranscriptsListScreen extends ConsumerStatefulWidget {
  const TranscriptsListScreen({super.key});

  @override
  ConsumerState<TranscriptsListScreen> createState() =>
      _TranscriptsListScreenState();
}

class _TranscriptsListScreenState extends ConsumerState<TranscriptsListScreen> {
  late Future<dynamic> _fetchTranscriptions;

  @override
  initState() {
    super.initState();
    _fetchTranscriptions =
        ref.read(transcriptsRepositoryProvider).fetchTranscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final transcriptionMockList = List.generate(
      10,
      (index) => Transcription(
        id: index,
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

    final repository = ref.watch(transcriptsRepositoryProvider);

    return FutureBuilder(
        future: _fetchTranscriptions,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snap.hasError) {
            return const Center(
              child: Text('Erro ao carregar transcrições'),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              await ref
                  .read(transcriptsRepositoryProvider)
                  .fetchTranscriptions();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  stretch: true,
                  pinned: true,
                  elevation: 0,
                  stretchTriggerOffset: 200.0,
                  expandedHeight: 120.0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(
                      left: 16,
                      bottom: 16,
                    ),
                    centerTitle: false,
                    title: Text(
                      'Minhas transcrições',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: transcriptionMockList.length,
                    (context, index) {
                      final e = transcriptionMockList[index];
                      final date = DateTime.parse(e.createdAt);
                      final hourPassed =
                          DateTime.now().difference(date).inHours;
                      final dayPassed = DateTime.now().difference(date).inDays;
                      final monthPassed =
                          DateTime.now().difference(date).inDays ~/ 30;

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
                          subtitle: Text(
                            e.text.length > 30
                                ? '${e.text.substring(0, 30)}...'
                                : e.text,
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
            ),
          );
        });
  }
}
