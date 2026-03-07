import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/package_entity.dart';
import '../repositories/package_repository.dart';

class GetPackageByIdUsecase {
  final IPackageRepository repository;

  GetPackageByIdUsecase(this.repository);

  Future<Either<Failure, PackageEntity>> call(String id) async {
    return repository.getPackageById(id);
  }
}
