import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:trip_planner/features/auth/presentation/state/auth_state.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/usecases/login_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/register_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';

// ✅ Simple Test Repository implementing IAuthRepository
class TestAuthRepository implements IAuthRepository {
  bool shouldFail = false;
  String? errorMessage;
  AuthEntity? returnUser;
  bool returnRegisterSuccess = true;
  bool returnLogoutSuccess = true;

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      return Left(ServerFailure(errorMessage ?? 'Register failed'));
    }
    return Right(returnRegisterSuccess);
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      return Left(ServerFailure(errorMessage ?? 'Login failed'));
    }
    return Right(
      returnUser ??
          const AuthEntity(
            id: '123',
            fullName: 'Test User',
            username: 'testuser',
            email: 'test@example.com',
            password: '',
          ),
    );
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage ?? 'Logout failed'));
    }
    return Right(returnLogoutSuccess);
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage ?? 'Get user failed'));
    }
    return Right(returnUser);
  }
}

void main() {
  group('Auth ViewModel Tests', () {
    late TestAuthRepository testRepository;
    late ProviderContainer container;

    setUp(() {
      testRepository = TestAuthRepository();

      // ✅ Override at USECASE level, not repository level
      container = ProviderContainer(
        overrides: [
          // Override each usecase with test instances
          registerUsecaseProvider.overrideWithValue(
            RegisterUsecase(testRepository),
          ),
          loginUsecaseProvider.overrideWithValue(LoginUsecase(testRepository)),
          logoutUsecaseProvider.overrideWithValue(
            LogoutUsecase(testRepository),
          ),
          getCurrentUserUsecaseProvider.overrideWithValue(
            GetCurrentUserUsecase(testRepository),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('1. Initial state should have status initial', () {
      // Act
      final state = container.read(authViewModelProvider);

      // Assert
      expect(state.status, AuthStatus.initial);
      expect(state.user, null);
      expect(state.errorMessage, null);
    });

    test('2. Register should change status to registered on success', () async {
      // Arrange
      testRepository.shouldFail = false;
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.register(
        fullName: 'New User',
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.registered);
      expect(state.errorMessage, null);
    });

    test('3. Register should set error status on failure', () async {
      // Arrange
      testRepository.shouldFail = true;
      testRepository.errorMessage = 'Email already exists';
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.register(
        fullName: 'Test User',
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Email already exists');
    });

    test('4. Login should set authenticated status on success', () async {
      // Arrange
      testRepository.shouldFail = false;
      testRepository.returnUser = const AuthEntity(
        id: '456',
        fullName: 'Login User',
        username: 'loginuser',
        email: 'login@example.com',
        password: '',
      );
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.login(
        email: 'login@example.com',
        password: 'password123',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, isNotNull);
      expect(state.user?.email, 'login@example.com');
    });

    test('5. Login should set error status on failure', () async {
      // Arrange
      testRepository.shouldFail = true;
      testRepository.errorMessage = 'Invalid credentials';
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.login(
        email: 'wrong@example.com',
        password: 'wrongpassword',
      );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
    });

    test('6. Logout should set unauthenticated status on success', () async {
      // Arrange
      testRepository.shouldFail = false;
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.logout();

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, null);
    });

    test('7. Logout should set error status on failure', () async {
      // Arrange
      testRepository.shouldFail = true;
      testRepository.errorMessage = 'Logout failed';
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.logout();

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Logout failed');
    });

    test(
      '8. GetCurrentUser should set authenticated when user exists',
      () async {
        // Arrange
        testRepository.shouldFail = false;
        testRepository.returnUser = const AuthEntity(
          id: '999',
          fullName: 'Current User',
          username: 'currentuser',
          email: 'current@example.com',
          password: '',
        );
        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.getCurrentUser();

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.authenticated);
        expect(state.user, isNotNull);
      },
    );

    test('9. GetCurrentUser should handle null user', () async {
      // Arrange
      testRepository.shouldFail = false;
      testRepository.returnUser = null;
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act
      await viewModel.getCurrentUser();

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, null);
    });

    test('10. Multiple login attempts should update state correctly', () async {
      // Arrange
      testRepository.shouldFail = true;
      testRepository.errorMessage = 'First error';
      final viewModel = container.read(authViewModelProvider.notifier);

      // Act - First login (fails)
      await viewModel.login(email: 'test1@example.com', password: 'password1');

      var state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'First error');

      // Act - Second login (succeeds)
      testRepository.shouldFail = false;
      testRepository.returnUser = const AuthEntity(
        id: '888',
        fullName: 'Success User',
        username: 'successuser',
        email: 'success@example.com',
        password: '',
      );

      await viewModel.login(email: 'success@example.com', password: 'password');

      // Assert
      state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.email, 'success@example.com');
    });
  });
}
