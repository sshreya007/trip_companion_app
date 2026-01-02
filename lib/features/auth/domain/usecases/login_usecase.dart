import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/data/repositories/auth_repository.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final IAuthRepository _repository;

  LoginUsecase(this._repository);

  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    return await _repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

/// Provider
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUsecase(repo);
});
