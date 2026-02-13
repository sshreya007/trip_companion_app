import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/package_entity.dart';
import '../repositories/package_repository.dart';

class GetFeaturedPackagesUsecase {
  final IPackageRepository repository;

  GetFeaturedPackagesUsecase(this.repository);

  Future<Either<Failure, List<PackageEntity>>> call({int limit = 6}) async {
    return repository.getFeaturedPackages(limit: limit);
  }
}
