import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final String? count;
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onTap;
  final double iconSize;

  const AppIconButton({
    super.key,
    required this.icon,
    this.count,
    this.isActive = false,
    this.activeColor = AppColors.pink,
    this.onTap,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : AppColors.textPrimary,
            size: iconSize,
          ),
          if (count != null) ...[
            const SizedBox(height: 4),
            Text(count!, style: AppTypography.countLabel),
          ],
        ],
      ),
    );
  }
}
