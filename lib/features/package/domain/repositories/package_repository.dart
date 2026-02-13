import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/package_entity.dart';

abstract class IPackageRepository {
  Future<Either<Failure, List<PackageEntity>>> getAllPackages(
    PackageFilterEntity filters,
  );
  Future<Either<Failure, PackageEntity>> getPackageById(String id);
  Future<Either<Failure, List<PackageEntity>>> getFeaturedPackages({
    int limit = 6,
  });
  Future<Either<Failure, List<PackageEntity>>> getPackagesByCategory(
    String category, {
    int limit = 10,
  });
  Future<Either<Failure, bool>> checkAvailability(String id);
}
