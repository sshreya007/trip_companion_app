import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id;
  final String username;
  final String email;
  final String? password;
  final String? status;

  const AuthEntity({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.status,
  });

  @override
  List<Object?> get props => [id, username, email, status];
}
