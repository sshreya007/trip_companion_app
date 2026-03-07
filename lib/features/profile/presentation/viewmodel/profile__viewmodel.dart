import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:trip_planner/features/profile/domain/entities/profile_entity.dart';
import 'package:trip_planner/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:trip_planner/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:trip_planner/features/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:trip_planner/features/profile/presentation/state/profile_state.dart';
import 'package:trip_planner/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:trip_planner/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:trip_planner/features/profile/data/repositories/profile_repository_impl.dart';

// Providers
final profileLocalDatasourceProvider = Provider<ProfileLocalDatasource>((ref) {
  return ProfileLocalDatasource();
});

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final dioClient = ref.read(dioClientProvider);
  return ProfileRemoteDatasource(dioClient);
});

final profileRepositoryProvider = Provider((ref) {
  final localDatasource = ref.read(profileLocalDatasourceProvider);
  final remoteDatasource = ref.read(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(localDatasource, remoteDatasource);
});

final getProfileUsecaseProvider = Provider((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetProfileUsecase(repository);
});

final updateProfileUsecaseProvider = Provider((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(repository);
});

final uploadProfileImageUsecaseProvider = Provider((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UploadProfileImageUsecase(repository);
});

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);

class ProfileViewModel extends Notifier<ProfileState> {
  late final GetProfileUsecase _getProfileUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;
  late final UploadProfileImageUsecase _uploadProfileImageUsecase;

  @override
  ProfileState build() {
    _getProfileUsecase = ref.read(getProfileUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _uploadProfileImageUsecase = ref.read(uploadProfileImageUsecaseProvider);

    return const ProfileState();
  }

  Future<void> getProfile(String userId) async {
    print('🎯 VIEWMODEL: Getting profile for $userId');

    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _getProfileUsecase(userId);

    result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to get profile - ${failure.message}');
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) {
        print('✅ VIEWMODEL: Profile loaded - ${profile.email}');
        state = state.copyWith(status: ProfileStatus.loaded, profile: profile);
      },
    );
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    print('🎯 VIEWMODEL: Updating profile');

    state = state.copyWith(status: ProfileStatus.updating);

    final result = await _updateProfileUsecase(profile);

    result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to update profile - ${failure.message}');
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (updatedProfile) {
        print('✅ VIEWMODEL: Profile updated successfully');
        state = state.copyWith(
          status: ProfileStatus.updated,
          profile: updatedProfile,
        );
      },
    );
  }

  Future<void> uploadProfileImage(File imageFile, String userId) async {
    print('🎯 VIEWMODEL: Uploading profile image');

    state = state.copyWith(status: ProfileStatus.uploadingImage);

    final result = await _uploadProfileImageUsecase(imageFile, userId);

    result.fold(
      (failure) {
        print('❌ VIEWMODEL: Failed to upload image - ${failure.message}');
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageUrl) {
        print('✅ VIEWMODEL: Image uploaded - $imageUrl');

        // Update profile with new image URL
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(
            profileImageUrl: imageUrl,
          );

          state = state.copyWith(
            status: ProfileStatus.imageUploaded,
            profile: updatedProfile,
            uploadedImageUrl: imageUrl,
          );

          // Save updated profile
          updateProfile(updatedProfile);
        }
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
