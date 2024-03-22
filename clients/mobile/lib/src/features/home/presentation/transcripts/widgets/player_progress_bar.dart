import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_detail_screen.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({
    super.key,
    required Stream<PositionData> positionDataStream,
    required AudioPlayer player,
  })  : _positionDataStream = positionDataStream,
        _player = player;

  final Stream<PositionData> _positionDataStream;
  final AudioPlayer _player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData?>(
      stream: _positionDataStream,
      builder: (ctx, snap) {
        final positionData = snap.data;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: ProgressBar(
            barHeight: 4,
            progress: positionData?.position ?? Duration.zero,
            total: positionData?.duration ?? Duration.zero,
            buffered: positionData?.bufferedPosition ?? Duration.zero,
            onSeek: _player.seek,
          ),
        );
      },
    );
  }
}
