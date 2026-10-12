class ServerException implements Exception {
  final String message;
  final String? code;
  const ServerException(this.message, {this.code});
}

class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException(this.message, {this.code});
}

class LocationException implements Exception {
  final String message;
  final String? code;
  const LocationException(this.message, {this.code});
}

class StorageException implements Exception {
  final String message;
  final String? code;
  const StorageException(this.message, {this.code});
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
