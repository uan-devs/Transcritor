import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transcritor/src/common/storage/normal/normal_storage.dart';

final normalStorageProvider = Provider<NormalStorage>((ref) {
  return NormalStorageImpl();
});

class NormalStorageImpl implements NormalStorage {
  @override
  Future<void> delete(String key) async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(key);
  }

  @override
  Future<String?> read(String key) async {
    final sp = await SharedPreferences.getInstance();

    return sp.getString(key);
  }

  @override
  Future<void> store(String key, String value) async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString(key, value);
  }
}