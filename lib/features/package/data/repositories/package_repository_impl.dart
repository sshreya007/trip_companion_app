import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/package/domain/entities/package_entity.dart';
import 'package:trip_planner/features/package/domain/repositories/package_repository.dart';
import 'package:trip_planner/features/package/data/datasources/remote/package_remote_datasource.dart';

class PackageRepositoryImpl implements IPackageRepository {
  final PackageRemoteDatasource _remoteDatasource;

  PackageRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<PackageEntity>>> getAllPackages(
    PackageFilterEntity filters,
  ) async {
    try {
      print('📁 REPOSITORY: Getting all packages');

      final packages = await _remoteDatasource.getAllPackages(filters);
      final entities = packages.map((model) => model.toEntity()).toList();

      print('📁 REPOSITORY: ${entities.length} packages retrieved');

      return Right(entities);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PackageEntity>> getPackageById(String id) async {
    try {
      print('📁 REPOSITORY: Getting package by ID: $id');

      final package = await _remoteDatasource.getPackageById(id);
      final entity = package.toEntity();

      print('📁 REPOSITORY: Package retrieved');

      return Right(entity);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PackageEntity>>> getFeaturedPackages({
    int limit = 6,
  }) async {
    try {
      print('📁 REPOSITORY: Getting featured packages');

      final packages = await _remoteDatasource.getFeaturedPackages(
        limit: limit,
      );
      final entities = packages.map((model) => model.toEntity()).toList();

      print('📁 REPOSITORY: ${entities.length} featured packages retrieved');

      return Right(entities);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PackageEntity>>> getPackagesByCategory(
    String category, {
    int limit = 10,
  }) async {
    try {
      print('📁 REPOSITORY: Getting packages by category: $category');

      final packages = await _remoteDatasource.getPackagesByCategory(
        category,
        limit: limit,
      );
      final entities = packages.map((model) => model.toEntity()).toList();

      print('📁 REPOSITORY: ${entities.length} packages retrieved');

      return Right(entities);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAvailability(String id) async {
    try {
      print('📁 REPOSITORY: Checking availability for: $id');

      final available = await _remoteDatasource.checkAvailability(id);

      print('📁 REPOSITORY: Availability: $available');

      return Right(available);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
