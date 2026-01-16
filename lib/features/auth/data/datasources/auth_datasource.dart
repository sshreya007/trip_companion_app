import 'package:trip_planner/features/auth/data/models/auth_api_model.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDatasource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthHiveModel?> register(AuthHiveModel user);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
}
