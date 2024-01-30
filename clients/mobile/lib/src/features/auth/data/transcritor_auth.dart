import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:transcritor/src/common/constants/urls.dart';
import 'package:transcritor/src/common/exceptions/auth_exception.dart';
import 'package:transcritor/src/common/models/user.dart';

final authTranscritorProvider = Provider<TranscritorAuth>(
  (ref) {
    return TranscritorAuth.instance;
  },
);

class TranscritorAuth {
  TranscritorAuth._internal();

  String? _token;
  User? _user;
  DateTime? _expiresAt;

  bool get isAuth {
    return _token != null && (_expiresAt?.isAfter(DateTime.now()) ?? false);
  }

  String? get token => _token;
  User? get user => _user;

  static TranscritorAuth? _instance;

  static TranscritorAuth get instance {
    return TranscritorAuth();
  }

  factory TranscritorAuth() {
    _instance ??= TranscritorAuth._internal();

    return _instance!;
  }

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
    required String province,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/signup'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'province': province,
        'phone': phone,
      },
    );

    final body = const JsonDecoder().convert(response.body);

    if (response.statusCode == 200) {
      _user = User.fromJson(response.body);
      _token = response.headers['x-auth-token'];
      _expiresAt = DateTime.parse(response.headers['x-auth-token-expires-at']!);

      return;
    } else if (response.body.isNotEmpty) {
      throw AuthException(key: body['error']);
    }

    throw AuthException(key: 'UNKNOWN');
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      _user = User.fromJson(response.body);
      _token = response.headers['x-auth-token'];
      _expiresAt = DateTime.parse(response.headers['x-auth-token-expires-at']!);

      return true;
    }

    return false;
  }

  void logout() {
    _user = null;
    _token = null;
    _expiresAt = null;
  }
}
