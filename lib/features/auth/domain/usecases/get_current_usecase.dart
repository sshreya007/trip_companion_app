import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/auth/data/repositories/auth_repository.dart';
import 'package:trip_planner/features/auth/domain/entities/auth_entity.dart';
import 'package:trip_planner/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final IAuthRepository _repository;

  GetCurrentUserUsecase(this._repository);

  Future<Either<Failure, AuthEntity>> call() async {
    return await _repository.getCurrentUser();
  }
}

/// Provider
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return GetCurrentUserUsecase(repo);
});
