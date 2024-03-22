import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:transcritor/src/common/widgets/adptative_widgets.dart';
import 'package:transcritor/src/features/home/data/transcripts_repository.dart';

final transcriptsControllerProvider = Provider<TranscriptListController>(
  (ref) => TranscriptListController(
    transcriptsRepository: ref.watch(transcriptsRepositoryProvider),
  ),
);

class TranscriptListController {
  final TranscriptsRepository transcriptsRepository;

  TranscriptListController({required this.transcriptsRepository});

  List<Transcription> get transcripts => transcriptsRepository.transcripts;

  int get transcriptsCount => transcripts.length;

  Future<void> fetchTranscriptions() async {
    await transcriptsRepository.fetchTranscriptions();
  }

  Future<void> deleteTranscription(int id, BuildContext context) async {
    final result = await transcriptsRepository.deleteTranscription(id);

    if (result.isRight()) {
      if (context.mounted) {
        await showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: const Text('Sucesso'),
              content: const Text('Transcrição excluída com sucesso'),
              actions: [
                AdaptiveWidgets.adaptiveAction(
                  context: context,
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (context.mounted) {
        await showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: const Text('Erro'),
              content: const Text('Erro ao excluir transcrição'),
              actions: [
                AdaptiveWidgets.adaptiveAction(
                  context: context,
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<bool?> confirmDeleteTranscription(int id, BuildContext context) async {
    return showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Excluir transcrição'),
          content: const Text('Deseja realmente excluir esta transcrição?'),
          actions: [
            AdaptiveWidgets.adaptiveAction(
                context: context,
                onPressed: () {
                  if (context.canPop()) context.pop(false);
                },
                child: const Text('Cancelar')
            ),
            AdaptiveWidgets.adaptiveAction(
                context: context,
                onPressed: () {
                  if (context.canPop()) context.pop(true);
                },
                child: const Text('Excluir')
            ),
          ],
        );
      },
    );
  }
}
