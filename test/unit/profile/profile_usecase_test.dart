import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:trip_planner/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:trip_planner/features/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:trip_planner/features/profile/domain/repositories/profile_repository.dart';
import 'package:trip_planner/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:trip_planner/core/errors/failure.dart';

// ✅ Simple test repository matching YOUR ProfileEntity
class TestProfileRepository implements IProfileRepository {
  // Track if methods were called
  bool getProfileCalled = false;
  bool updateProfileCalled = false;
  bool uploadProfileImageCalled = false;

  // Store last call parameters
  String? lastUserId;
  ProfileEntity? lastProfile;
  File? lastImageFile;

  // Control return values
  ProfileEntity? returnProfile;
  String? returnImageUrl;
  Failure? returnFailure;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    getProfileCalled = true;
    lastUserId = userId;

    if (returnFailure != null) {
      return Left(returnFailure!);
    }

    return Right(
      returnProfile ??
          ProfileEntity(
            id: userId,
            name: 'Test User',
            email: 'test@example.com',
            gender: 'Male',
            age: 25,
            profileImageUrl: 'https://example.com/default.jpg',
          ),
    );
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    updateProfileCalled = true;
    lastProfile = profile;

    if (returnFailure != null) {
      return Left(returnFailure!);
    }

    return Right(profile);
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(
    File imageFile,
    String userId,
  ) async {
    uploadProfileImageCalled = true;
    lastImageFile = imageFile;
    lastUserId = userId;

    if (returnFailure != null) {
      return Left(returnFailure!);
    }

    return Right(returnImageUrl ?? 'https://example.com/uploaded-image.jpg');
  }
}

void main() {
  group('Profile UseCase Tests', () {
    late TestProfileRepository testRepository;
    late GetProfileUsecase getProfileUsecase;
    late UpdateProfileUsecase updateProfileUsecase;
    late UploadProfileImageUsecase uploadProfileImageUsecase;

    setUp(() {
      testRepository = TestProfileRepository();
      getProfileUsecase = GetProfileUsecase(testRepository);
      updateProfileUsecase = UpdateProfileUsecase(testRepository);
      uploadProfileImageUsecase = UploadProfileImageUsecase(testRepository);
    });

    test('1. GetProfileUsecase should call repository with userId', () async {
      // Arrange
      const userId = 'user123';

      // Act
      await getProfileUsecase(userId);

      // Assert
      expect(testRepository.getProfileCalled, true);
      expect(testRepository.lastUserId, userId);
    });

    test(
      '2. UpdateProfileUsecase should call repository with profile',
      () async {
        // Arrange
        const profile = ProfileEntity(
          id: 'user456',
          name: 'Updated Name',
          email: 'updated@example.com',
          gender: 'Female',
          age: 30,
          profileImageUrl: 'https://example.com/updated.jpg',
        );

        // Act
        await updateProfileUsecase(profile);

        // Assert
        expect(testRepository.updateProfileCalled, true);
        expect(testRepository.lastProfile, profile);
        expect(testRepository.lastProfile?.name, 'Updated Name');
        expect(testRepository.lastProfile?.email, 'updated@example.com');
      },
    );

    test(
      '3. UploadProfileImageUsecase should call repository with file and userId',
      () async {
        // Arrange
        final imageFile = File('test/fixtures/test_image.jpg');
        const userId = 'user789';

        // Act
        await uploadProfileImageUsecase(imageFile, userId);

        // Assert
        expect(testRepository.uploadProfileImageCalled, true);
        expect(testRepository.lastImageFile, imageFile);
        expect(testRepository.lastUserId, userId);
      },
    );

    test(
      '4. GetProfileUsecase should return ProfileEntity successfully',
      () async {
        // Arrange
        const userId = 'user999';
        testRepository.returnProfile = const ProfileEntity(
          id: 'user999',
          name: 'John Doe',
          email: 'john@example.com',
          gender: 'Male',
          age: 35,
          profileImageUrl: 'https://example.com/john.jpg',
        );

        // Act
        final result = await getProfileUsecase(userId);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (profile) {
          expect(profile.id, 'user999');
          expect(profile.name, 'John Doe');
          expect(profile.email, 'john@example.com');
          expect(profile.gender, 'Male');
          expect(profile.age, 35);
        });
      },
    );

    test(
      '5. UploadProfileImageUsecase should return image URL successfully',
      () async {
        // Arrange
        final imageFile = File('test/fixtures/profile_pic.jpg');
        const userId = 'user888';
        testRepository.returnImageUrl =
            'https://cdn.example.com/images/profile_888.jpg';

        // Act
        final result = await uploadProfileImageUsecase(imageFile, userId);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (imageUrl) {
          expect(imageUrl, 'https://cdn.example.com/images/profile_888.jpg');
          expect(imageUrl.startsWith('https://'), true);
        });
      },
    );
  });
}
