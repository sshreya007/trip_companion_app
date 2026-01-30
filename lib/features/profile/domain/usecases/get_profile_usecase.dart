import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final IProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<Either<Failure, ProfileEntity>> call(String userId) async {
    return repository.getProfile(userId);
  }
}
