import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _tokenKey = 'auth_token';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

class TokenStorage {
  final FlutterSecureStorage _storage;
  const TokenStorage(this._storage);

  Future<void> save(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> read() => _storage.read(key: _tokenKey);
  Future<void> clear() => _storage.delete(key: _tokenKey);
}

final tokenStorageProvider = Provider((ref) => TokenStorage(ref.watch(secureStorageProvider)));
