import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/data/repositories/auth_repository.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final IAuthRepository _repository;

  LogoutUsecase(this._repository);

  Future<Either<Failure, bool>> call(LogoutParams params) async {
    return await _repository.logout(params.id);
  }
}

class LogoutParams {
  final String id;
  LogoutParams({required this.id});
}

/// Provider
final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LogoutUsecase(repo);
});
