import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trip_planner/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/login_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/register_usecase.dart';
import 'package:trip_planner/features/auth/presentation/state/auth_state.dart';

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
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    return const AuthState();
  }

  /// Register User
  Future<void> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    String? phoneNumber,
    String? batchId,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _registerUsecase(
      RegisterParams(email: email, username: username, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        message: failure.message,
      ),
      (_) => state = state.copyWith(status: AuthStatus.registered),
    );
  }

  /// Login User
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _loginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        message: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  /// Get current logged-in user
  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        message: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  /// Logout User
  Future<void> logout({required String id}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase(LogoutParams(id: id));

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        message: failure.message,
      ),
      (_) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ),
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(message: null);
  }
}
