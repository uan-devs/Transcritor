import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:transcritor/src/common/utils/my_colors.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/transcript_recorder_screen.dart';
import 'package:transcritor/src/features/home/presentation/transcripts/widgets/media_player.dart';


class TranscriptCreateScreen extends StatefulWidget {
  const TranscriptCreateScreen({super.key});

  @override
  State<TranscriptCreateScreen> createState() => _TranscriptCreateScreenState();
}

class _TranscriptCreateScreenState extends State<TranscriptCreateScreen> {
  File? _file;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'wav', 'flac', 'm4a'],
      allowMultiple: false,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _deleteFile() async {
    await _file!.delete();
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            pinned: true,
            floating: true,
            snap: true,
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
                'Criar transcrição',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (ctx, anim1, anim2) {
                      return Dismissible(
                        key: const Key('dialog'),
                        direction: DismissDirection.down,
                        onDismissed: (direction) {
                          if (context.canPop()) {
                            context.pop();
                          }
                        },
                        child: const TranscriptRecorderScreen(),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.mic),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_file == null)
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: const Text('Selecionar arquivo multimídia'),
                      ),
                    if (_file != null) ...[
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          await _deleteFile();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 20),
                      MediaPlayer(file: _file!),
                      const Spacer(),
                      SlideAction(
                        onSubmit: () {},
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
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
