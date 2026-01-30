import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';
import 'package:trip_planner/features/profile/domain/entities/profile_entity.dart';
import 'package:trip_planner/features/profile/domain/repositories/profile_repository.dart';
import 'package:trip_planner/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:trip_planner/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:trip_planner/features/profile/data/models/profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileLocalDatasource _localDatasource;
  final ProfileRemoteDatasource _remoteDatasource;

  ProfileRepositoryImpl(this._localDatasource, this._remoteDatasource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      print('📁 REPOSITORY: Getting profile for $userId');

      // Try local first
      final localProfile = await _localDatasource.getProfile(userId);

      if (localProfile != null) {
        print('📁 REPOSITORY: Found in local storage');
        return Right(localProfile.toEntity());
      }

      // If not in local, fetch from remote
      print('📁 REPOSITORY: Fetching from remote');
      final remoteProfile = await _remoteDatasource.getProfile(userId);

      // Save to local
      await _localDatasource.saveProfile(remoteProfile);

      return Right(remoteProfile.toEntity());
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      print('📁 REPOSITORY: Updating profile');

      final model = ProfileModel.fromEntity(profile);

      // Update remotely
      final updatedProfile = await _remoteDatasource.updateProfile(model);

      // Save to local
      await _localDatasource.updateProfile(updatedProfile);

      print('📁 REPOSITORY: Profile updated successfully');

      return Right(updatedProfile.toEntity());
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(
    File imageFile,
    String userId,
  ) async {
    try {
      print('📁 REPOSITORY: Uploading profile image');

      // Upload to remote
      final imageUrl = await _remoteDatasource.uploadProfileImage(
        imageFile,
        userId,
      );

      print('📁 REPOSITORY: Image uploaded successfully');
      print('🔗 Image URL: $imageUrl');

      return Right(imageUrl);
    } catch (e) {
      print('❌ REPOSITORY ERROR: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
