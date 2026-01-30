import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginUsecase {
  final IAuthRepository repository;
  LoginUsecase(this.repository);

  Future<Either<Failure, AuthEntity>> call(
    String email,
    String password,
  ) async {
    return repository.login(email, password);
  }
}
