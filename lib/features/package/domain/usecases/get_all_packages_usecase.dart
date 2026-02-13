import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/package_entity.dart';
import '../repositories/package_repository.dart';

class GetAllPackagesUsecase {
  final IPackageRepository repository;

  GetAllPackagesUsecase(this.repository);

  Future<Either<Failure, List<PackageEntity>>> call(
    PackageFilterEntity filters,
  ) async {
    return repository.getAllPackages(filters);
  }
}
