import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/core/service/connectivity/network_info.dart';
import 'package:trip_planner/features/auth/data/datasources/auth_datasource.dart';
import 'package:trip_planner/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:trip_planner/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:trip_planner/features/auth/data/datasources/remote/auth_remote_datasource_provider.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
    authRemoteDatasource: null,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDatasource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthDatasource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
    required authRemoteDatasource,
  }) : _authDatasource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo;

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
  Future<Either<Failure, bool>> logout(String id) async {
    try {
      final result = await _authDatasource
          .logout(); // make sure datasource accepts id
      return result ? Right(true) : Left(LocalDatabaseFailure('Logout failed'));
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
