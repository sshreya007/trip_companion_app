import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/features/auth/domain/usecases/login_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/register_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trip_planner/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';

// ✅ Simple test repository matching YOUR interface
class TestAuthRepository implements IAuthRepository {
  // Track if methods were called
  bool loginCalled = false;
  bool registerCalled = false;
  bool logoutCalled = false;
  bool getCurrentUserCalled = false;

  // Store last call parameters
  String? lastEmail;
  String? lastPassword;
  AuthEntity? lastAuthEntity;

  // Control return values
  AuthEntity? returnUser;
  bool returnRegisterSuccess = true;
  bool returnLogoutSuccess = true;
  Failure? returnFailure;

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    registerCalled = true;
    lastAuthEntity = entity;

    if (returnFailure != null) {
      return Left(returnFailure!);
    }

    return Right(returnRegisterSuccess);
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    loginCalled = true;
    lastEmail = email;
    lastPassword = password;

    if (returnFailure != null) {
      return Left(returnFailure!);
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
    logoutCalled = true;

    if (returnFailure != null) {
      return Left(returnFailure!);
    }

    return Right(returnLogoutSuccess);
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    getCurrentUserCalled = true;

    if (returnFailure != null) {
      return Left(returnFailure!);
    }

    return Right(returnUser);
  }
}

void main() {
  group('Auth UseCase Tests', () {
    late TestAuthRepository testRepository;
    late LoginUsecase loginUsecase;
    late RegisterUsecase registerUsecase;
    late LogoutUsecase logoutUsecase;
    late GetCurrentUserUsecase getCurrentUserUsecase;

    setUp(() {
      testRepository = TestAuthRepository();
      loginUsecase = LoginUsecase(testRepository);
      registerUsecase = RegisterUsecase(testRepository);
      logoutUsecase = LogoutUsecase(testRepository);
      getCurrentUserUsecase = GetCurrentUserUsecase(testRepository);
    });

    test('1. LoginUsecase should call repository login method', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      await loginUsecase(email, password);

      // Assert
      expect(testRepository.loginCalled, true);
      expect(testRepository.lastEmail, email);
      expect(testRepository.lastPassword, password);
    });

    test('2. RegisterUsecase should call repository register method', () async {
      // Arrange
      const authEntity = AuthEntity(
        id: '',
        fullName: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        password: 'password123',
      );

      // Act
      await registerUsecase(authEntity);

      // Assert
      expect(testRepository.registerCalled, true);
      expect(testRepository.lastAuthEntity, authEntity);
      expect(testRepository.lastAuthEntity?.fullName, 'John Doe');
      expect(testRepository.lastAuthEntity?.email, 'john@example.com');
    });

    test('3. LogoutUsecase should call repository logout method', () async {
      // Act
      await logoutUsecase();

      // Assert
      expect(testRepository.logoutCalled, true);
    });

    test(
      '4. GetCurrentUserUsecase should call repository getCurrentUser',
      () async {
        // Act
        await getCurrentUserUsecase();

        // Assert
        expect(testRepository.getCurrentUserCalled, true);
      },
    );

    test(
      '5. RegisterUsecase should return true when registration succeeds',
      () async {
        // Arrange
        testRepository.returnRegisterSuccess = true;
        const authEntity = AuthEntity(
          id: '',
          fullName: 'Success User',
          username: 'successuser',
          email: 'success@example.com',
          password: 'password123',
        );

        // Act
        final result = await registerUsecase(authEntity);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (success) => expect(success, true),
        );
      },
    );
  });
}
