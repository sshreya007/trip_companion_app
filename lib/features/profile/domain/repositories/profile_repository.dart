import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';

abstract class IProfileRepository {
  Future<Either<Failure, bool>> uploadProfilePhoto(File image);
}
