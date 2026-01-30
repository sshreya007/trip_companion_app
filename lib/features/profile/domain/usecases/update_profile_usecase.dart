import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUsecase {
  final IProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<Either<Failure, ProfileEntity>> call(ProfileEntity profile) async {
    return repository.updateProfile(profile);
  }
}
