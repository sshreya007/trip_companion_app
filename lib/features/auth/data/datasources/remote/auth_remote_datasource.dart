import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/api/api_client.dart';
import 'package:trip_planner/api/api_endpoints.dart';
import 'package:trip_planner/features/auth/data/datasources/auth_datasource.dart';
import 'package:trip_planner/features/auth/data/models/auth_api_model.dart';
import 'package:trip_planner/features/auth/data/models/auth_hive_model.dart';

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  // Provider for AuthRemoteDatasource
  final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
    final apiClient = ref.read(apiClientProvider);
    return AuthRemoteDatasource(apiClient: apiClient);
  });

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.studentLogin,
      data: {"email": email, "password": password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return AuthHiveModel.fromJson(data);
    }

    throw Exception(response.data['message'] ?? 'Login failed');
  }

  @override
  Future<bool> logout() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> register(AuthHiveModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.students,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return AuthHiveModel.fromJson(data);
    }

    throw Exception(response.data['message'] ?? 'Registration failed');
  }
}
