// lib/core/failures/failure.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NoDataFailure extends Failure {
  const NoDataFailure(super.message);
}
