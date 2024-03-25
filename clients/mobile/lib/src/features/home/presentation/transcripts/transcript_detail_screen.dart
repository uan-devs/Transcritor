import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_list_controller.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/media_display_card.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/player_controls.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/player_progress_bar.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/transcript_text_box.dart';

class TranscriptDetailScreen extends ConsumerStatefulWidget {
  const TranscriptDetailScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  ConsumerState<TranscriptDetailScreen> createState() =>
      _TranscriptDetailScreenState();
}

class _TranscriptDetailScreenState
    extends ConsumerState<TranscriptDetailScreen> {
  late Future<Transcription?> _fetchTranscription;
  late AudioPlayer _player;

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest3<Duration?, Duration?, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream, (position, bufferedPosition, duration) {
      return PositionData(
        position ?? Duration.zero,
        bufferedPosition ?? Duration.zero,
        duration ?? Duration.zero,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTranscription = ref
        .read(transcriptsControllerProvider.notifier)
        .getUpdatedTranscription(widget.id);
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('transcript_detail_screen'),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _fetchTranscription,
          builder: (context, snap) {
            if (snap.hasError) {
              return const Center(
                child: Text('Erro ao carregar transcrição'),
              );
            }

            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final transcription = snap.data;

            if (transcription == null || !transcription.hasAllElements()) {
              return const Center(
                child: Text('Erro ao carregar transcrição'),
              );
            }

            _player = AudioPlayer()..setUrl(transcription.multimedia!.url!);

            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.grey[800]!,
                    MyColors.black87,
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  // Custom appbar
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            iconSize: 50,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              }
                            },
                          ),
                        ),
                      ),
                      Text(
                        transcription.multimedia!.name.split('.').first,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            child: MediaDisplayCard(),
                          ),
                          const SizedBox(height: 80),
                          // Audio progress bar
                          PlayerProgressBar(
                            positionDataStream: _positionDataStream,
                            player: _player,
                          ),
                          PlayerControls(player: _player),
                          const SizedBox(height: 80),
                          // Box to display the transcription with auto scroll
                          TranscriptTextBox(
                            transcription: transcription,
                            player: _player,
                            positionDataStream: _positionDataStream,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PositionData {
  PositionData(this.position, this.bufferedPosition, this.duration);

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}
