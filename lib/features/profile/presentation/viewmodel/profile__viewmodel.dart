// import 'dart:io';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../state/profile_state.dart';
// import '../../domain/usecases/upload_profile_photo_usecase.dart';

// final profileViewModelProvider =
//     NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);

// class ProfileViewModel extends Notifier<ProfileState> {
//   late final UploadProfilePhotoUsecase _uploadUsecase;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   ProfileState build() {
//     return const ProfileState();
//   }

//   Future<void> pickFromCamera() async {
//     final status = await Permission.camera.request();
//     if (!status.isGranted) {
//       state = state.copyWith(errorMessage: "Camera permission denied");
//       return;
//     }

//     final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
//     if (picked != null) {
//       _upload(File(picked.path));
//     }
//   }

//   Future<void> pickFromGallery() async {
//     final status = await Permission.photos.request();
//     if (!status.isGranted) {
//       state = state.copyWith(errorMessage: "Gallery permission denied");
//       return;
//     }

//     final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       _upload(File(picked.path));
//     }
//   }

//   Future<void> _upload(File image) async {
//     state = state.copyWith(status: ProfileStatus.loading);

//     final result = await _uploadUsecase(image);

//     result.fold(
//       (failure) => state = state.copyWith(
//         status: ProfileStatus.error,
//         errorMessage: failure.message,
//       ),
//       (_) =>
//           state = state.copyWith(status: ProfileStatus.success, image: image),
//     );
//   }
// }
