class ServerException implements Exception {
  final String message;
  final String? code;
  const ServerException(this.message, {this.code});

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

class LocationException implements Exception {
  final String message;
  final String? code;
  const LocationException(this.message, {this.code});

  @override
  String toString() => message;
}

class StorageException implements Exception {
  final String message;
  final String? code;
  const StorageException(this.message, {this.code});

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => message;
}
