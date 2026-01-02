import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/data/repositories/auth_repository.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final IAuthRepository _repository;

  RegisterUsecase(this._repository);

  Future<Either<Failure, bool>> call(RegisterParams params) async {
    final entity = AuthEntity(
      id: params.id ?? '', // optional if generating inside repository
      username: params.username,
      email: params.email,
      password: params.password,
    );
    return await _repository.register(entity);
  }
}

class RegisterParams {
  final String username;
  final String email;
  final String password;
  final String? id; // optional
  RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    this.id,
  });
}

/// Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return RegisterUsecase(repo);
});
