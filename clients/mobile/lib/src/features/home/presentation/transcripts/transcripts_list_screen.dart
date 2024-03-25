import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_detail_screen.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_list_controller.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/transcript_item.dart';

class TranscriptsListScreen extends ConsumerStatefulWidget {
  const TranscriptsListScreen({super.key});

  @override
  ConsumerState<TranscriptsListScreen> createState() =>
      _TranscriptsListScreenState();
}

class _TranscriptsListScreenState extends ConsumerState<TranscriptsListScreen> {
  late Future<void> _fetchTranscriptions;

  @override
  initState() {
    super.initState();
    _fetchTranscriptions = ref
        .read(transcriptsControllerProvider.notifier)
        .fetchTranscriptions();
  }

  @override
  Widget build(BuildContext context) {
    List<Transcription> transcripts = ref.watch(transcriptsControllerProvider);

    return FutureBuilder(
        future: _fetchTranscriptions,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snap.hasError) {
            final error = snap.error.toString();

            return RefreshIndicator.adaptive(
              onRefresh: () async {
                setState(() {
                  _fetchTranscriptions = ref
                      .read(transcriptsControllerProvider.notifier)
                      .fetchTranscriptions();
                });
              },
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(error),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              setState(() {
                _fetchTranscriptions = ref
                    .read(transcriptsControllerProvider.notifier)
                    .fetchTranscriptions();
              });
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
                if (transcripts.isEmpty) ...[
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'Comece por criar uma transcrição',
                      ),
                    ),
                  ),
                ] else ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: transcripts.length,
                      (context, index) {
                        final e = transcripts[index];
                        final date = DateTime.parse(e.createdAt);
                        final hourPassed =
                            DateTime.now().difference(date).inHours;
                        final dayPassed =
                            DateTime.now().difference(date).inDays;
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Dismissible(
                            key: ValueKey(e.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await ref
                                  .read(transcriptsControllerProvider.notifier)
                                  .confirmDeleteTranscription(e.id, context);
                            },
                            child: TranscriptItem(
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  transitionDuration: const Duration(
                                    milliseconds: 225,
                                  ),
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end);
                                    final offsetAnimation = anim1.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  pageBuilder: (context, anim1, anim2) {
                                    return TranscriptDetailScreen(
                                      id: e.id,
                                    );
                                  },
                                );
                              },
                              transcription: e,
                              createdAt: createdAt,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
