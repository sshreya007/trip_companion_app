import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';

import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileLocalDatasource datasource;

  ProfileRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> uploadProfilePhoto(File image) async {
    try {
      final result = await datasource.uploadProfilePhoto(image);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }
}
