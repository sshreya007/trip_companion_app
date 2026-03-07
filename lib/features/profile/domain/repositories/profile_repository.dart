import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../entities/profile_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, String>> uploadProfileImage(
    File imageFile,
    String userId,
  );
}
