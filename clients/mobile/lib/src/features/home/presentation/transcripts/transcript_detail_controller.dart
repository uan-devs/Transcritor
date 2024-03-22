import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/exceptions/auth_exception.dart';
import 'package:transcritor/src/common/models/transcription.dart';
import 'package:transcritor/src/features/home/data/transcripts_repository.dart';

final transcriptDetailControllerProvider = Provider<TranscriptDetailController>(
  (ref) => TranscriptDetailController(
    transcriptsRepository: ref.watch(transcriptsRepositoryProvider),
  ),
);

class TranscriptDetailController {
  final TranscriptsRepository transcriptsRepository;

  TranscriptDetailController({required this.transcriptsRepository});

  List<Transcription> get transcripts => transcriptsRepository.transcripts;

  Future<Either<AuthException, Transcription>> getAndUpdateTranscription(int id) async {
    return await transcriptsRepository.getAndUpdateTranscription(id);
  }
}
