import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:transcritor/src/common/constants/storage_keys.dart';
import 'package:transcritor/src/common/constants/urls.dart';
import 'package:transcritor/src/common/storage/secure/secure_storage_impl.dart';
import 'package:transcritor/src/common/storage/storage.dart';

final restClientProvider = Provider<RestClient>((ref) {
  final storage = ref.read(secureStorageProvider);

  return RestClient(storage: storage);
});

final class RestClient {
  final Storage storage;

  RestClient({required this.storage});

  String get baseUrl => _baseUrl.toString();

  RestClient get auth {
    _isAuth = true;

    return this;
  }

  RestClient get unAuth {
    _isAuth = false;

    return this;
  }

  String _baseUrl = UrlsConstants.baseURL;
  final Map<String, String> _headers = {"Content-Type": "application/json"};
  bool _isAuth = false;

  set baseUrl(String value) {
    _baseUrl = value;
  }

  Future<void> _authenticateRequest() async {
    final accessToken = await storage.read(StorageKeys.accessToken);
    _headers['Authorization'] = 'Bearer $accessToken';
  }

  Future<http.Response> postRequest(
      String path, Map<String, Object> body) async {
    if (_isAuth) {
      await _authenticateRequest();
    }

    return await http.post(
      Uri.parse('$_baseUrl$path'),
      body: jsonEncode(body),
      headers: _headers,
    );
  }

  Future<http.Response> getRequest(String path) async {
    if (_isAuth) {
      await _authenticateRequest();
    }

    return await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
  }

  Future<http.Response> patchRequest(
      String path, Map<String, Object> body) async {
    if (_isAuth) {
      await _authenticateRequest();
    }

    return await http.patch(
      Uri.parse('$_baseUrl$path'),
      body: body,
      headers: _headers,
    );
  }
}
