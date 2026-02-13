import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/package_entity.dart';
import '../repositories/package_repository.dart';

class GetPackagesByCategoryUsecase {
  final IPackageRepository repository;

  GetPackagesByCategoryUsecase(this.repository);

  Future<Either<Failure, List<PackageEntity>>> call(
    String category, {
    int limit = 10,
  }) async {
    return repository.getPackagesByCategory(category, limit: limit);
  }
}
