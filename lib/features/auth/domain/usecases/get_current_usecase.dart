import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final IAuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, AuthEntity>> call(GetCurrentUserParams params) async {
    return await _repository.getCurrentUser();
  }
}

class GetCurrentUserParams {
  final String id; // id of the current user

  GetCurrentUserParams({required this.id});
}
