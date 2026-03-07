import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String password;

  const AuthEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [id, fullName, username, email, password];
}
