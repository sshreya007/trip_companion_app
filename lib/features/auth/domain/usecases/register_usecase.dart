import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final IAuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, bool>> call(RegisterParams params) async {
    final entity = AuthEntity(
      id: params.id,
      username: params.username,
      email: params.email,
      password: params.password,
    );
    return await _repository.register(entity);
  }
}

class RegisterParams {
  final String? id; // optional, if you want to allow generated IDs
  final String username;
  final String email;
  final String password;

  RegisterParams({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });
}
