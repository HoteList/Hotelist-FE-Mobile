import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  // ignore: prefer_const_constructors
  static final _storage = FlutterSecureStorage();
  static const _keyToken = 'token';

  static Future setToken(String token) async => await _storage.write(key: _keyToken, value: token);
  static Future<String?> getToken() async => await _storage.read(key: _keyToken);
  static Future deleteToken() async => await _storage.delete(key: _keyToken);
}