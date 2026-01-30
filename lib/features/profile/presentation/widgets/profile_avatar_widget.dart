import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatarWidget({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.size = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.teal, width: 3),
        ),
        child: ClipOval(child: _buildImage()),
      ),
    );
  }

  Widget _buildImage() {
    // Priority: Local file > Network URL > Default icon
    if (imageFile != null) {
      return Image.file(imageFile!, fit: BoxFit.cover);
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => _buildDefaultAvatar(),
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.person, size: size * 0.6, color: Colors.grey[600]),
    );
  }
}
