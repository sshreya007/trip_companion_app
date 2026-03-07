// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:trip_planner/features/profile/presentation/viewmodel/profile__viewmodel.dart';

// import '../state/profile_state.dart';

// class ProfilePage extends ConsumerWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(profileViewModelProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Profile")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 60,
//             backgroundImage: state.image != null
//                 ? FileImage(state.image!)
//                 : const AssetImage("assets/images/default_avatar.png")
//                       as ImageProvider,
//           ),
//           const SizedBox(height: 20),

//           ElevatedButton.icon(
//             onPressed: () =>
//                 ref.read(profileViewModelProvider.notifier).pickFromCamera(),
//             icon: const Icon(Icons.camera_alt),
//             label: const Text("Camera"),
//           ),

//           ElevatedButton.icon(
//             onPressed: () =>
//                 ref.read(profileViewModelProvider.notifier).pickFromGallery(),
//             icon: const Icon(Icons.image),
//             label: const Text("Gallery"),
//           ),

//           if (state.status == ProfileStatus.loading)
//             const Padding(
//               padding: EdgeInsets.all(10),
//               child: CircularProgressIndicator(),
//             ),

//           if (state.errorMessage != null)
//             Text(
//               state.errorMessage!,
//               style: const TextStyle(color: Colors.red),
//             ),
//         ],
//       ),
//     );
//   }
// }
