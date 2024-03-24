import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_detail_screen.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/player_controls.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/player_progress_bar.dart';

class MediaPlayer extends StatefulWidget {
  const MediaPlayer({super.key, required this.file});

  final File file;

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()..setFilePath(widget.file.path);
  }

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayerProgressBar(
          positionDataStream: _positionDataStream,
          player: _player,
        ),
        PlayerControls(player: _player),
      ],
    );
  }
}
