import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/api/api_client.dart';
import 'package:trip_planner/features/auth/data/datasources/auth_datasource.dart';
import 'package:trip_planner/features/auth/data/datasources/remote/auth_remote_datasource.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Provider for AuthRemoteDatasource
final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteDatasource(apiClient: apiClient);
});
