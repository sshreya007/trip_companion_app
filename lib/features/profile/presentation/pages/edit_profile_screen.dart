import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/features/profile/domain/entities/profile_entity.dart';

import 'package:trip_planner/features/profile/presentation/state/profile_state.dart';
import 'package:trip_planner/features/profile/presentation/viewmodel/profile__viewmodel.dart';
import 'package:trip_planner/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:trip_planner/features/profile/presentation/widgets/image_picker_bottom_sheet.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final ProfileEntity? profile;
  final String userId;

  const EditProfileScreen({
    super.key,
    required this.profile,
    required this.userId,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController ageController;

  String? selectedGender;
  File? selectedImage;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.profile?.name ?? '');
    emailController = TextEditingController(text: widget.profile?.email ?? '');
    ageController = TextEditingController(
      text: widget.profile?.age?.toString() ?? '',
    );
    selectedGender = widget.profile?.gender;
    currentImageUrl = widget.profile?.profileImageUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    // Listen to state changes
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.updated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }

      if (next.status == ProfileStatus.imageUploaded &&
          next.uploadedImageUrl != null) {
        setState(() {
          currentImageUrl = next.uploadedImageUrl;
        });
      }

      if (next.status == ProfileStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(profileViewModelProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Photo Section
              Column(
                children: [
                  const Text(
                    'Photo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  Stack(
                    children: [
                      ProfileAvatarWidget(
                        imageUrl: currentImageUrl,
                        imageFile: selectedImage,
                        size: 120,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePicker,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _showImagePicker,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Image'),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Name Field
              _buildTextField(
                controller: nameController,
                label: 'Name',
                icon: Icons.person,
                hint: 'Enter your name',
              ),

              const SizedBox(height: 15),

              // Gender Selector
              _buildGenderSelector(),

              const SizedBox(height: 15),

              // Age Field
              _buildTextField(
                controller: ageController,
                label: 'Age',
                icon: Icons.cake,
                hint: 'Enter your age',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 15),

              // Email Field (Read-only)
              _buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email,
                hint: 'Email',
                enabled: false,
              ),

              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      profileState.status == ProfileStatus.updating ||
                          profileState.status == ProfileStatus.uploadingImage
                      ? null
                      : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      profileState.status == ProfileStatus.updating ||
                          profileState.status == ProfileStatus.uploadingImage
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.teal),
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGender,
              isExpanded: true,
              hint: const Text('Select Gender'),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        onImageSelected: (File file) {
          setState(() {
            selectedImage = file;
          });

          // Upload image immediately
          ref
              .read(profileViewModelProvider.notifier)
              .uploadProfileImage(file, widget.userId);
        },
      ),
    );
  }

  void _saveProfile() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    int? age;
    if (ageController.text.trim().isNotEmpty) {
      age = int.tryParse(ageController.text.trim());
      if (age == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid age')),
        );
        return;
      }
    }

    final updatedProfile = ProfileEntity(
      id: widget.userId,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      gender: selectedGender,
      age: age,
      profileImageUrl: currentImageUrl,
    );

    ref.read(profileViewModelProvider.notifier).updateProfile(updatedProfile);
  }
}
