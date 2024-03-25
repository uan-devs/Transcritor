import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:transcritor/src/common/widgets/adptative_widgets.dart';
import 'package:transcritor/src/features/home/data/transcripts_repository.dart';

final transcriptsControllerProvider =
    NotifierProvider<TranscriptListController, List<Transcription>>(
  () {
    return TranscriptListController();
  },
);

class TranscriptListController extends Notifier<List<Transcription>> {
  @override
  List<Transcription> build() {
    return [];
  }

  int get transcriptsCount => state.length;

  Future<void> fetchTranscriptions() async {
    final result =
        await ref.read(transcriptsRepositoryProvider).fetchTranscriptions();

    if (result.isRight()) {
      state = result.getOrElse(() => []);
    } else {
      return Future.error('Erro ao carregar transcrições');
    }
  }

  Future<bool> deleteTranscription(int id, BuildContext context) async {
    final result = await ref.read(transcriptsRepositoryProvider).deleteTranscription(id);

    if (result.isRight()) {
      state = state.where((element) => element.id != id).toList();

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

      return true;
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

      return false;
    }
  }

  Future<bool?> confirmDeleteTranscription(int id, BuildContext context) async {
    final canDelete = await showAdaptiveDialog<bool>(
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
                child: const Text('Cancelar')),
            AdaptiveWidgets.adaptiveAction(
                context: context,
                onPressed: () {
                  if (context.canPop()) context.pop(true);
                },
                child: const Text('Excluir')),
          ],
        );
      },
    );

    if (canDelete != null) {
      if (canDelete && context.mounted) {
        return await deleteTranscription(id, context);
      }

      return false;
    }

    return false;
  }

  Future<Transcription?> getUpdatedTranscription(
      int id) async {
    final transcription = state.firstWhereOrNull((element) => element.id == id);

    if (transcription != null && transcription.hasAllElements()) {
      return transcription;
    } else {
      final result = await ref.read(transcriptsRepositoryProvider).getAndUpdateTranscription(id);

      if (result.isRight()) {
        final updatedTranscription = result.getOrElse(() => throw Exception());

        int index = state.indexWhere((element) => element.id == id);

        if (index != -1) {
          state[index] = updatedTranscription;
        }

        return updatedTranscription;
      }

      return null;
    }
  }
}

/*
Este é um dos últimos testes que farei na aplicação móvel do serviço de transcrição
de áudio pertencente à universidade estatal.
* */
