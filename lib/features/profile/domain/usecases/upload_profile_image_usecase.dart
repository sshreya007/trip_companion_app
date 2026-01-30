import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import '../repositories/profile_repository.dart';

class UploadProfileImageUsecase {
  final IProfileRepository repository;

  UploadProfileImageUsecase(this.repository);

  Future<Either<Failure, String>> call(File imageFile, String userId) async {
    return repository.uploadProfileImage(imageFile, userId);
  }
}
