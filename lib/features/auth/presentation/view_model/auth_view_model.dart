import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/auth/domain/usecases/login_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/register_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trip_planner/features/auth/presentation/state/auth_state.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:trip_planner/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:trip_planner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trip_planner/core/network/dio_client.dart';

// 1. Provider for DioClient
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// 2. Provider for AuthLocalDatasource
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasource();
});

// 3. Provider for AuthRemoteDatasource
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return AuthRemoteDatasource(dioClient);
});

// 4. Provider for AuthRepository (now with both local and remote)
final authRepositoryProvider = Provider((ref) {
  final localDatasource = ref.read(authLocalDatasourceProvider);
  final remoteDatasource = ref.read(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(localDatasource, remoteDatasource);
});

// 5. Provider for RegisterUsecase
final registerUsecaseProvider = Provider((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RegisterUsecase(repository);
});

// 6. Provider for LoginUsecase
final loginUsecaseProvider = Provider((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUsecase(repository);
});

// 7. Provider for GetCurrentUserUsecase
final getCurrentUserUsecaseProvider = Provider((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetCurrentUserUsecase(repository);
});

// 8. Provider for LogoutUsecase
final logoutUsecaseProvider = Provider((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUsecase(repository);
});

// 9. AuthViewModel Provider
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final LogoutUsecase _logoutUsecase;

  @override
  AuthState build() {
    // ✅ PROPERLY INJECT USECASES
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);

    return const AuthState();
  }

  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    print('🎯 REGISTER VIEWMODEL START');

    state = state.copyWith(status: AuthStatus.loading);

    final entity = AuthEntity(
      id: '',
      fullName: fullName,
      username: username,
      email: email,
      password: password,
    );

    print('🎯 ENTITY CREATED: ${entity.email}');

    final result = await _registerUsecase(entity);

    print('🎯 REGISTER USECASE RETURNED');

    result.fold(
      (failure) {
        print('❌ REGISTER FAILED: ${failure.message}');
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        print('✅ REGISTER SUCCESS');
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    print('🎯 LOGIN START');
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _loginUsecase(email, password);
    result.fold(
      (failure) {
        print('❌ LOGIN FAILED: ${failure.message}');
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        print('✅ LOGIN SUCCESS: ${user.email}');
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      },
    );
  }

  Future<void> getCurrentUser() async {
    final result = await _getCurrentUserUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> logout() async {
    final result = await _logoutUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ),
    );
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}
