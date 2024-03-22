import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_detail_screen.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_list_controller.dart';

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
        ref.read(transcriptsControllerProvider).fetchTranscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(transcriptsControllerProvider);

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
                  .read(transcriptsControllerProvider)
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
                if (controller.transcripts.isEmpty) ...[
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
                      childCount: controller.transcripts.length,
                      (context, index) {
                        final e = controller.transcripts[index];
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

                        return TranscriptItem(
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

class TranscriptItem extends StatelessWidget {
  const TranscriptItem({
    super.key,
    required this.transcription,
    required this.createdAt,
    required this.onTap,
  });

  final Transcription transcription;
  final String createdAt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          transcription.multimedia!.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          transcription.text.length > 30
              ? '${transcription.text.substring(0, 30)}...'
              : transcription.text,
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
  }
}
