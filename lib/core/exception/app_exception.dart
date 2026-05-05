// lib/core/exceptions/app_exception.dart
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class NoDataException extends AppException {
  const NoDataException(super.message);
}

class CancelException extends AppException {
  const CancelException(super.message);
}
