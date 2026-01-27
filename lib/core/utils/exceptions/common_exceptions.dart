class NoInternetException implements Exception {
  final String message;
  NoInternetException({required this.message});
}

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}

class InvalidCredsException implements Exception {
  final String message;
  InvalidCredsException({required this.message});
}

class ApiException implements Exception {
  final String message;
  ApiException({required this.message});
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

class SocketException implements Exception {
  final String message;
  SocketException({required this.message});
}
