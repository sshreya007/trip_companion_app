import 'package:equatable/equatable.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? user;
  final String? message;

  const AuthState({this.status = AuthStatus.initial, this.user, this.message});

  AuthState copyWith({AuthStatus? status, AuthEntity? user, String? message}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];

  /// Initial state
  factory AuthState.initial() => const AuthState();

  /// Loading state
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  /// Authenticated state
  factory AuthState.authenticated(AuthEntity user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  /// Unauthenticated state
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  /// Registered state
  factory AuthState.registered() =>
      const AuthState(status: AuthStatus.registered);

  /// Error state
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, message: message);

  get errorMessage => null;
}
