/// Abstract Failure class
abstract class Failure {
  final String message;
  Failure(this.message);
}

/// General local database failure (Hive, SQLite, etc.)
class LocalDatabaseFailure extends Failure {
  LocalDatabaseFailure(String message) : super(message);
}

/// Other failures (optional)
class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}
