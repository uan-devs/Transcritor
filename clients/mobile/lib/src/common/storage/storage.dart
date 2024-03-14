abstract class Storage {
  Future<void> store(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}
