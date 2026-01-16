import 'package:trip_planner/features/auth/data/datasources/auth_datasource.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> register(AuthHiveModel user) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
