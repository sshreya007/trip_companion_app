import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';
import 'package:trip_planner/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:trip_planner/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthLocalDatasource _localDatasource;
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._localDatasource, this._remoteDatasource);

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      print('📁 REPOSITORY: Starting remote registration');

      final model = AuthHiveModel.fromEntity(entity);

      // 1. Register remotely
      final remoteUser = await _remoteDatasource.register(model);

      print('📁 REPOSITORY: Remote success, saving locally');

      // 2. Save to local database
      await _localDatasource.register(remoteUser);

      print('📁 REPOSITORY: Registration complete');

      return const Right(true);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      print('📁 REPOSITORY: Starting remote login');

      // 1. Login remotely
      final remoteUser = await _remoteDatasource.login(email, password);

      print('📁 REPOSITORY: Remote login success, saving locally');

      // 2. Save to local database
      await _localDatasource.register(remoteUser); // This updates if exists

      // 3. Set as current user
      final box = Hive.box('prefsBox');
      await box.put('currentUserEmail', email);

      print('📁 REPOSITORY: Login complete');

      return Right(remoteUser.toEntity());
    } catch (e) {
      print('❌ REPOSITORY LOGIN ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    try {
      // Try local first
      final localUser = await _localDatasource.getCurrentUser();

      if (localUser != null) {
        return Right(localUser.toEntity());
      }

      // If no local user, try remote
      final remoteUser = await _remoteDatasource.getCurrentUser();

      if (remoteUser != null) {
        // Save to local
        await _localDatasource.register(remoteUser);
        return Right(remoteUser.toEntity());
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // Logout remotely
      await _remoteDatasource.logout();

      // Logout locally
      await _localDatasource.logout();

      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
