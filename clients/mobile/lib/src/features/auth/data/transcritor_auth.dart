import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcritor/src/common/api/rest_client.dart';
import 'package:transcritor/src/common/constants/storage_keys.dart';
import 'package:transcritor/src/common/constants/urls.dart';
import 'package:transcritor/src/common/exceptions/auth_exception.dart';
import 'package:transcritor/src/common/extensions/custom_string_extension.dart';
import 'package:transcritor/src/common/models/user.dart';
import 'package:transcritor/src/common/storage/normal/normal_storage_impl.dart';
import 'package:transcritor/src/common/storage/secure/secure_storage_impl.dart';
import 'package:transcritor/src/common/storage/storage.dart';
import 'package:transcritor/src/features/auth/data/auth_repository.dart';

final authTranscritorProvider = Provider<TranscritorAuth>(
  (ref) {
    final restClient = ref.watch(restClientProvider);
    final secureStorage = ref.read(secureStorageProvider);
    final normalStorage = ref.read(normalStorageProvider);

    return TranscritorAuth(
      client: restClient,
      secureStorage: secureStorage,
      normalStorage: normalStorage,
    );
  },
);

class TranscritorAuth implements AuthRepository {
  final RestClient client;
  final Storage secureStorage;
  final Storage normalStorage;

  TranscritorAuth({
    required this.client,
    required this.secureStorage,
    required this.normalStorage,
  }) {
    _userStream.stream.listen((event) {
      _user = event;
    });
    _userStream.sink.add(null);
  }

  User? _user;

  User? get user => _user;

  final _userStream = StreamController<User?>.broadcast(sync: true);

  Future<void> autoLogin() async {
    final accessToken = await secureStorage.read(StorageKeys.accessToken);
    final refreshToken = await secureStorage.read(StorageKeys.refreshToken);
    final expiresIn = await normalStorage.read(StorageKeys.expiresIn);

    if (accessToken != null && refreshToken != null && expiresIn != null) {
      final now = DateTime.now();
      final expires = DateTime.parse(expiresIn);

      if (now.isBefore(expires)) {
        final userFromStorage = await getCurrentUserInfoFromStorage();

        if (userFromStorage != null) {
          _userStream.sink.add(userFromStorage);
        } else {
          getCurrentUserInfo();
        }
      } else {
        final refreshTokenExpiresIn =
            await normalStorage.read(StorageKeys.refreshTokenExpiresIn);

        if (refreshTokenExpiresIn != null) {
          final refreshTokenExpires = DateTime.parse(refreshTokenExpiresIn);

          if (now.isBefore(refreshTokenExpires)) {
            final response = await client.unAuth.postRequest(
              path: UrlsConstants.refreshTokenUrl,
              body: {
                'refresh_token': refreshToken,
              },
            );

            if (response.statusCode == 200) {
              final body = jsonDecode(response.body);

              if (body['access_token'] != null &&
                  body['refresh_token'] != null) {
                await Future.wait([
                  secureStorage.store(
                    StorageKeys.accessToken,
                    body['access_token'] ?? '',
                  ),
                  secureStorage.store(
                    StorageKeys.refreshToken,
                    body['refresh_token'] ?? '',
                  ),
                  normalStorage.store(
                    StorageKeys.expiresIn,
                    DateTime.now()
                        .add(const Duration(minutes: 990))
                        .toIso8601String(),
                  ),
                  normalStorage.store(
                    StorageKeys.refreshTokenExpiresIn,
                    DateTime.now()
                        .add(const Duration(minutes: 4990))
                        .toIso8601String(),
                  ),
                ]);

                getCurrentUserInfo();
              }
            }
          }
        }
      }
    }
  }

  Future<User?> getCurrentUserInfoFromStorage() async {
    final userInfo = await normalStorage.read(StorageKeys.userInfo);

    if (userInfo != null) {
      return User.fromJson(userInfo);
    }

    return null;
  }

  @override
  Future<Either<AuthException, User?>> getCurrentUserInfo() async {
    try {
      final response =
          await client.auth.getRequest(path: UrlsConstants.userInfoUrl);

      switch (response.statusCode) {
        case 400:
          return Left(AuthException(key: 'BAD_REQUEST'));
        case 401:
          return Left(AuthException(key: 'INVALID_CREDENTIALS'));
        case 403:
          return Left(AuthException(key: 'OPERATION_NOT_ALLOWED'));
        case 200:
          late User? apiUser;

          try {
            apiUser = User.fromJson(response.body);
          } catch (e) {
            return Left(AuthException(key: 'BAD_RESPONSE'));
          }

          await normalStorage.store(
            StorageKeys.userInfo,
            apiUser.toJson(),
          );

          _userStream.sink.add(apiUser);

          return Right(apiUser);
        default:
          return Left(AuthException(key: 'SERVER_DOWN'));
      }
    } catch (e) {
      return Left(AuthException(key: e.toString()));
    }
  }

  @override
  Stream<User?> onAuthStateChanged() {
    return _userStream.stream;
  }

  @override
  Future<Either<AuthException, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.unAuth.postRequest(
        path: UrlsConstants.loginUrl,
        body: {
          'email': email,
          'password': password,
        },
      );

      switch (response.statusCode) {
        case 400:
          debugPrint(
              'response: ${jsonDecode(response.body)} - ${response.statusCode}');
          return Left(AuthException(key: 'BAD_REQUEST'));
        case 401:
          debugPrint(
              'response: ${jsonDecode(response.body)} - ${response.statusCode}');
          return Left(AuthException(key: 'INVALID_CREDENTIALS'));
        case 200:
          final body = jsonDecode(response.body);

          debugPrint(
              'response: ${jsonDecode(response.body)} - ${response.statusCode}');

          if (body['access_token'] != null && body['refresh_token'] != null) {
            await Future.wait([
              secureStorage.store(
                StorageKeys.accessToken,
                body['access_token'] ?? '',
              ),
              secureStorage.store(
                StorageKeys.refreshToken,
                body['refresh_token'] ?? '',
              ),
              normalStorage.store(
                StorageKeys.expiresIn,
                DateTime.now()
                    .add(const Duration(minutes: 990))
                    .toIso8601String(),
              ),
              normalStorage.store(
                StorageKeys.refreshTokenExpiresIn,
                DateTime.now()
                    .add(const Duration(minutes: 4990))
                    .toIso8601String(),
              ),
            ]);

            getCurrentUserInfo();
          } else {
            return Left(AuthException(key: ''));
          }

          return const Right(null);
        default:
          return Left(AuthException(key: 'SERVER_DOWN'));
      }
    } catch (e) {
      return Left(AuthException(key: e.toString()));
    }
  }

  @override
  Future<void> signOut() {
    return Future.wait([
      secureStorage.delete(StorageKeys.accessToken),
      secureStorage.delete(StorageKeys.refreshToken),
      normalStorage.delete(StorageKeys.expiresIn),
      normalStorage.delete(StorageKeys.refreshTokenExpiresIn),
      normalStorage.delete(StorageKeys.userInfo),
    ]).then((value) {
      _userStream.sink.add(null);
    });
  }

  @override
  Future<Either<AuthException, void>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String province,
  }) async {
    try {
      final response = await client.unAuth.postRequest(
        path: UrlsConstants.registerUrl,
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'province': province,
        },
      );

      switch (response.statusCode) {
        case 400:
          return Left(AuthException(key: 'BAD_REQUEST'));
        case 201:
          final body = jsonDecode(response.body);

          if (body['access_token'] != null && body['refresh_token'] != null) {
            await Future.wait([
              secureStorage.store(
                StorageKeys.accessToken,
                body['access_token'] ?? '',
              ),
              secureStorage.store(
                StorageKeys.refreshToken,
                body['refresh_token'] ?? '',
              ),
              normalStorage.store(
                StorageKeys.expiresIn,
                DateTime.now()
                    .add(const Duration(minutes: 990))
                    .toIso8601String(),
              ),
              normalStorage.store(
                StorageKeys.refreshTokenExpiresIn,
                DateTime.now()
                    .add(const Duration(minutes: 4990))
                    .toIso8601String(),
              ),
            ]);

            getCurrentUserInfo();
          } else {
            return Left(AuthException(key: ''));
          }

          return const Right(null);
        default:
          return Left(AuthException(key: 'SERVER_DOWN'));
      }
    } catch (e) {
      return Left(AuthException(key: e.toString()));
    }
  }

  Future<Either<AuthException, User?>> editUser({
    required String? firstName,
    required String? lastName,
    required String? birthDate,
    required File? image,
  }) async {
    if (firstName == null &&
        lastName == null &&
        birthDate == null &&
        image == null) {
      return Right(_user);
    }

    if (image == null) {
      debugPrint('editUserInfo');
      return await editUserInfo(
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
      );
    }

    if (firstName == null && lastName == null && birthDate == null) {
      return await editProfileImage(
        image: image,
      );
    }

    await editProfileImage(image: image);

    return await editUserInfo(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
    );
  }

  @override
  Future<Either<AuthException, User?>> editProfileImage({
    required File image,
  }) async {
    try {
      final response = await client.auth.sendFile(
        path: UrlsConstants.editUserProfilePhotoUrl,
        file: image,
        fieldName: 'photo',
        method: 'PATCH',
      );

      debugPrint('request feito ${response.statusCode} - ${response.body}');

      switch (response.statusCode) {
        case 400:
          return Left(AuthException(key: 'BAD_REQUEST'));
        case 401:
          return Left(AuthException(key: 'INVALID_CREDENTIALS'));
        case 403:
          return Left(AuthException(key: 'OPERATION_NOT_ALLOWED'));
        case 200:
          late User? apiUser;

          try {
            apiUser = User.fromJson(response.body);
          } catch (e) {
            return Left(AuthException(key: 'BAD_RESPONSE'));
          }

          await normalStorage.store(
            StorageKeys.userInfo,
            apiUser.toJson(),
          );

          _userStream.sink.add(apiUser);

          return Right(apiUser);
        default:
          return Left(AuthException(key: 'SERVER_DOWN'));
      }
    } catch (e) {
      return Left(AuthException(key: e.toString()));
    }
  }

  @override
  Future<Either<AuthException, User?>> editUserInfo({
    required String? firstName,
    required String? lastName,
    required String? birthDate,
  }) async {
    if (firstName.isEmptyOrNull &&
        lastName.isEmptyOrNull &&
        birthDate.isEmptyOrNull) {
      return Right(_user);
    }

    if (firstName == _user?.firstName &&
        lastName == _user?.lastName &&
        (birthDate == _user?.dateOfBirth || birthDate.isEmptyOrNull)) {
      return Right(_user);
    }

    final Map<String, Object> body = {};

    (firstName.isEmptyOrNull || firstName == _user?.firstName)
        ? null
        : body['firstName'] = firstName!;
    (lastName.isEmptyOrNull || lastName == _user?.lastName)
        ? null
        : body['lastName'] = lastName!;
    (birthDate.isEmptyOrNull || birthDate == _user?.dateOfBirth)
        ? null
        : body['dateOfBirth'] = birthDate!;

    try {
      final response = await client.auth.patchRequest(
        path: UrlsConstants.editUserInfoUrl,
        body: body,
      );

      debugPrint('request feito ${response.statusCode} with body: $body');

      switch (response.statusCode) {
        case 400:
          debugPrint(response.body);
          return Left(AuthException(key: 'BAD_REQUEST'));
        case 401:
          debugPrint(response.body);
          return Left(AuthException(key: 'INVALID_CREDENTIALS'));
        case 403:
          debugPrint(response.body);
          return Left(AuthException(key: 'OPERATION_NOT_ALLOWED'));
        case 200:
          debugPrint(response.body);
          late User? apiUser;

          try {
            apiUser = User.fromJson(response.body);
          } catch (e) {
            debugPrint(e.toString());
            return Left(AuthException(key: 'BAD_RESPONSE'));
          }

          await normalStorage.store(
            StorageKeys.userInfo,
            apiUser.toJson(),
          );

          _userStream.sink.add(apiUser);

          return Right(apiUser);
        default:
          debugPrint(response.body);
          return Left(AuthException(key: 'SERVER_DOWN'));
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(AuthException(key: e.toString()));
    }
  }
}
