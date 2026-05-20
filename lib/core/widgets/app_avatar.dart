import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool hasBorder;
  final Color borderColor;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    required this.imageUrl,
    this.size = 48,
    this.hasBorder = false,
    this.borderColor = AppColors.pink,
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
          border: hasBorder ? Border.all(color: borderColor, width: 2) : null,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: size,
            height: size,
            placeholder: (context, url) => Container(
              color: AppColors.card,
              child: const Icon(Icons.person, color: AppColors.textSecondary),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.card,
              child: const Icon(Icons.person, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
