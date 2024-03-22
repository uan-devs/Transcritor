import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required AudioPlayer player,
  }) : _player = player;

  final AudioPlayer _player;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10),
          iconSize: 64.0,
          onPressed: () {
            _player.seek(
              _player.position < const Duration(seconds: 10)
                  ? Duration.zero
                  : _player.position - const Duration(seconds: 10),
            );
          },
        ),
        const SizedBox(width: 20),
        StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;

              if (!(playing ?? false)) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: _player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: _player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => _player.seek(Duration.zero),
                );
              }
            }),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.forward_10),
          iconSize: 64.0,
          onPressed: () {
            _player.seek(
              _player.position >=
                  _player.duration! - const Duration(seconds: 10)
                  ? _player.duration
                  : _player.position + const Duration(seconds: 10),
            );
          },
        ),
      ],
    );
  }
}