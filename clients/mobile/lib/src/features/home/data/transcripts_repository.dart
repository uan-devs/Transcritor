import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/api/rest_client.dart';
import 'package:transcritor/src/common/constants/urls.dart';
import 'package:transcritor/src/common/exceptions/auth_exception.dart';
import 'package:transcritor/src/common/models/transcription.dart';

final transcriptsRepositoryProvider = Provider<TranscriptsRepository>(
      (ref) =>
      TranscriptsRepository(
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

    if (transcription != null &&
        transcription.sentences != null &&
        transcription.sentences!.isNotEmpty) {
      return Right(transcription);
    } else {
      final response = await restClient.auth.getRequest(
        path: '${UrlsConstants.singleTranscriptionUrl}$id',
      );

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
              _transcripts[index] = updatedTranscription;
            }

            return Right(updatedTranscription);
          } catch (e) {
            return Left(AuthException(key: 'BAD_RESPONSE'));
          }
        default:
          return Left(AuthException(key: ''));
      }
    }
  }

  Future<Either<AuthException, List<Transcription>>>
  fetchTranscriptions() async {
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

            final apiList = <Transcription>[];

            for (var element in body) {
              apiList.add(Transcription.fromMap(element));
            }

            _transcripts.clear();
            _transcripts.addAll(apiList);

            break;
          } catch (e) {
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
    try {
      final response = await restClient.auth.deleteRequest(
        path: '${UrlsConstants.singleTranscriptionUrl}$id',
      );

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
    } catch (e) {
      return Left(AuthException(key: ''));
    }
  }

  Future<Either<AuthException, Transcription>> createTranscription(
      File file) async {
    try {
      final response = await restClient.auth.sendFile(
        path: UrlsConstants.createTranscriptionUrl,
        fieldName: 'media',
        file: file,
        method: 'POST',
        type: 'audio',
        subtype: file.path
            .split('.')
            .last,
      );

      switch (response.statusCode) {
        case 401:
        case 403:
          return Left(AuthException(key: 'INVALID_CREDENTIALS'));
        case 201:
          try {
            final transcription = Transcription.fromJson(response.body);
            _transcripts.add(transcription);
            return Right(transcription);
          } catch (e) {
            return Left(AuthException(key: 'BAD_RESPONSE'));
          }
        default:
          return Left(AuthException(key: ''));
      }
    } catch (e) {
      return Left(AuthException(key: ''));
    }
  }
}
