import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/data/datasources/auth_datasource.dart';
import 'package:trip_planner/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDatasource;

  AuthRepository({required IAuthDatasource authDatasource})
    : _authDatasource = authDatasource;

  /// Register user
  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      final model = AuthHiveModel.fromEntity(entity, password: '');
      final result = await _authDatasource.register(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure('Failed to register user'));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  /// Login user
  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final model = await _authDatasource.login(email, password);
      if (model == null)
        return Left(LocalDatabaseFailure('Invalid email or password'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  /// Logout user
  @override
  Future<Either<Failure, AuthEntity>> logout(String id) async {
    try {
      final result = await _authDatasource.logout(); // pass id to datasource
      if (!result) return Left(LocalDatabaseFailure('Logout failed'));

      // You can return a dummy AuthEntity or the current user info if needed
      return Right(AuthEntity(id: id, username: '', email: '', password: ''));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  /// Get current logged-in user
  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authDatasource.getCurrentUser();
      if (model == null) return Left(LocalDatabaseFailure('No user found'));
      return Right(model.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }
}
