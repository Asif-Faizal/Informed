import 'package:equatable/equatable.dart';

// Base class for failures
abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

// Server failure class
class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Cache failure class
class CacheFailure extends Failure {
  final String message;

  const CacheFailure(this.message);

  @override
  List<Object?> get props => [message];
}
