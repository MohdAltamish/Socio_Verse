import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CountBadge extends StatelessWidget {
  final String count;
  final Color backgroundColor;
  final Color textColor;

  const CountBadge({
    super.key,
    required this.count,
    this.backgroundColor = AppColors.pink,
    this.textColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
