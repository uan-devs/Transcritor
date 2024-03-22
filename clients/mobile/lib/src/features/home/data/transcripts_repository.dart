import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/api/rest_client.dart';
import 'package:transcritor/src/common/constants/urls.dart';
import 'package:transcritor/src/common/exceptions/auth_exception.dart';
import 'package:transcritor/src/common/models/transcription.dart';

final transcriptsRepositoryProvider = Provider<TranscriptsRepository>(
  (ref) => TranscriptsRepository(
    restClient: ref.watch(restClientProvider),
  ),
);

class TranscriptsRepository {
  final RestClient restClient;

  TranscriptsRepository({required this.restClient});

  final List<Transcription> _transcripts = [];

  List<Transcription> get transcripts => [..._transcripts];

  Future<Either<AuthException, Transcription>> getAndUpdateTranscription(
      int id) async {
    final transcription = _transcripts.firstWhereOrNull(
      (element) => element.id == id,
    );

    if (transcription != null && transcription.sentences != null && transcription.sentences!.isNotEmpty) {
      return Right(transcription);
    } else {
      final response = await restClient.auth.getRequest(
        path: '${UrlsConstants.singleTranscriptionUrl}$id',
      );

      debugPrint('Path: ${UrlsConstants.singleTranscriptionUrl}/$id');
      debugPrint('Fetching transcription...: ${response.statusCode}');

      switch (response.statusCode) {
        case 401:
        case 403:
          return Left(AuthException(key: 'INVALID_CREDENTIALS'));
        case 200:
          try {
            final body = jsonDecode(response.body);
            final updatedTranscription = Transcription.fromMap(body);

            int index = _transcripts.indexWhere((element) => element.id == id);
            if (index != -1) {
              debugPrint('Updating transcription...');
              _transcripts[index] = updatedTranscription;
            }

            return Right(updatedTranscription);
          } catch (e) {
            debugPrint('Error: $e');
            return Left(AuthException(key: 'BAD_RESPONSE'));
          }
        default:
          return Left(AuthException(key: ''));
      }
    }
  }

  Future<Either<AuthException, List<Transcription>>>
      fetchTranscriptions() async {
    debugPrint('Fetching transcriptions...');
    try {
      final response = await restClient.auth
          .getRequest(path: UrlsConstants.fetchTranscriptionsUrl);

      switch (response.statusCode) {
        case 401:
        case 403:
          return Left(AuthException(key: 'INVALID_CREDENTIALS'));
        case 200:
          try {
            final body = jsonDecode(response.body) as List;

            for (var element in body) {
              _transcripts.add(Transcription.fromMap(element));
            }

            break;
          } catch (e) {
            debugPrint('Error: $e');
            return Left(AuthException(key: 'BAD_RESPONSE'));
          }
        default:
          return Left(AuthException(key: ''));
      }

      return Right(_transcripts);
    } catch (e) {
      return Left(AuthException(key: ''));
    }
  }

  Future<Either<AuthException, void>> deleteTranscription(int id) async {
    final response = await restClient.auth.deleteRequest(
      path: '${UrlsConstants.singleTranscriptionUrl}$id',
    );

    debugPrint('Path: ${UrlsConstants.singleTranscriptionUrl}/$id');
    debugPrint('Deleting transcription...: ${response.statusCode}');

    switch (response.statusCode) {
      case 401:
      case 403:
        return Left(AuthException(key: 'INVALID_CREDENTIALS'));
      case 204:
        _transcripts.removeWhere((element) => element.id == id);
        return const Right(null);
      default:
        return Left(AuthException(key: ''));
    }
  }
}
