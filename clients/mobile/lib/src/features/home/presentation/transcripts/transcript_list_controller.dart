import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/models/transcription.dart';
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
}