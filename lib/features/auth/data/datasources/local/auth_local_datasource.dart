import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/core/providers/hive_service_provider.dart';
import 'package:trip_planner/core/service/hive/hive_service.dart';
import 'package:trip_planner/features/auth/data/datasources/auth_datasource.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

// Provider for AuthLocalDatasource
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService _hiveService;

  // Correct constructor syntax
  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      // Fixed call to hiveService
      await _hiveService.logoutUser; // add () to call the method
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      await _hiveService.registerUser(model); // add () to call the method
      return true;
    } catch (e) {
      return false;
    }
  }
}
