import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/home/data/transcripts_repository.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/media_player.dart';

class UploadRecorder extends ConsumerStatefulWidget {
  const UploadRecorder({super.key, required this.recorder});

  final AudioRecorder recorder;

  @override
  ConsumerState<UploadRecorder> createState() => _UploadRecorderState();
}

class _UploadRecorderState extends ConsumerState<UploadRecorder> {
  bool _isRecording = false;
  bool _isLoading = false;
  Timer? _timer;
  File? _file;

  String get _timerText {
    final minutes = (_timer?.tick ?? 0) ~/ 60;
    final seconds = (_timer?.tick ?? 0) % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get _randomFileName {
    final faker = Faker();
    final randomName = faker.animal.name();
    final randomString = Random().nextInt(1000).toString();

    return '${randomString}_$randomName.m4a';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timer = timer;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _startRecording() async {
    _startTimer();
    setState(() {
      _isRecording = true;
    });

    Directory? dir;

    try {
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');

        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return;
    }

    if (dir == null) {
      debugPrint('Error: Directory is null');
      return;
    }

    final path = '${dir.path}/$_randomFileName';

    await widget.recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
      ),
      path: path,
    );
  }

  Future<void> _stopRecording() async {
    _stopTimer();
    setState(() {
      _isRecording = false;
      _isLoading = true;
    });

    final result = await widget.recorder.stop();

    if (result != null) {
      _file = File(result);
      debugPrint('Recording saved at: ${_file?.path}');
    } else {
      debugPrint('Error: Recording not saved');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading) ...[const CircularProgressIndicator.adaptive()],
          if (_file != null) ...[
            const Spacer(),
            MediaPlayer(file: _file!),
            const Spacer(),
            SlideAction(
              onSubmit: () async {
                if (_file == null) {
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                await ref
                    .read(transcriptsRepositoryProvider)
                    .createTranscription(_file!);

                setState(() {
                  _file = null;
                  _isLoading = false;
                });
              },
              elevation: 20,
              text: 'Deslize para enviar',
              innerColor: MyColors.green.withOpacity(.7),
              outerColor: MyColors.green.withOpacity(.3),
              sliderButtonIcon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ] else ...[
            Text(
              _isRecording ? _timerText : '0:00',
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onLongPressStart: (details) async {
                debugPrint('Recording...');
                await _startRecording();
              },
              onLongPressEnd: (details) async {
                debugPrint('Recording stopped');
                await _stopRecording();
              },
              child: Material(
                color: MyColors.green,
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(100),
                  overlayColor: MaterialStateProperty.all(
                    Colors.grey.withOpacity(.3),
                  ),
                  splashFactory: InkSplash.splashFactory,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.mic,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isRecording
                  ? 'Largue para parar'
                  : 'Pressione e segure para gravar',
            ),
          ],
        ],
      ),
    );
  }
}
