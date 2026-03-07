import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity?>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
}
