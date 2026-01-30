import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final IAuthRepository repository;
  RegisterUsecase(this.repository);

  Future<Either<Failure, bool>> call(AuthEntity entity) async {
    return repository.register(entity);
  }
}
