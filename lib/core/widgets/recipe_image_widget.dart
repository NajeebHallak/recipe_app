import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';

class RecipeImageWidget extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;

  const RecipeImageWidget({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _buildErrorPlaceholder();
    }

    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: fit,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    }
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: Colors.grey.shade400, size: 40.rSp),
            AppGap.h4,
            Text(
              'لا يمكن عرض الصورة',
              style: TextStyle(color: Colors.grey, fontSize: 12.rSp),
            ),
          ],
        ),
      ),
    );
  }
}
