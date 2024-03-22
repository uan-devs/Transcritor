import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:transcritor/src/common/extensions/custom_string_extension.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_detail_screen.dart';

class TranscriptTextBox extends StatefulWidget {
  const TranscriptTextBox({
    super.key,
    required this.transcription,
    required this.player,
    required this.positionDataStream,
  });

  final Transcription transcription;
  final AudioPlayer player;
  final Stream<PositionData> positionDataStream;

  @override
  State<TranscriptTextBox> createState() => _TranscriptTextBoxState();
}

class _TranscriptTextBoxState extends State<TranscriptTextBox> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        decoration: BoxDecoration(
          color: MyColors.grey600,
          borderRadius: BorderRadius.circular(20),
        ),
        // Display all sentences here
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Transcrição',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.black26,
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.open_in_full),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<PositionData?>(
                  stream: widget.positionDataStream,
                  builder: (context, snap) {
                    final data = snap.data;

                    _scrollController.animateTo(
                      (data?.position.inSeconds.toDouble() ?? 0) * 40,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                    );

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.transcription.sentences!.length,
                      itemBuilder: (context, index) {
                        final sentenceFinalTime = Duration(
                          seconds: int.parse(
                            widget.transcription.sentences![index].finalTime,
                          ),
                        );
                        final sentenceInitialTime = Duration(
                          seconds: int.parse(
                            widget.transcription.sentences![index].initialTime,
                          ),
                        );
                        final highlighted = (data?.position ?? Duration.zero) >=
                                sentenceInitialTime &&
                            (data?.position ?? Duration.zero) <=
                                sentenceFinalTime;

                        return Text(
                          widget.transcription.sentences![index].sentence
                              .toCapitalCase,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: highlighted ? Colors.white : Colors.grey,
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
