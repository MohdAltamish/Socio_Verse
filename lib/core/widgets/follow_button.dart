import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class FollowButton extends StatefulWidget {
  final bool isFollowing;
  final VoidCallback onToggle;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onToggle,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _widthAnimation = Tween<double>(
      begin: 88,
      end: 108,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isFollowing) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFollowing != oldWidget.isFollowing) {
      if (widget.isFollowing) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 32,
            constraints: BoxConstraints(
              minWidth: widget.isFollowing ? 108 : 88,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isFollowing ? AppColors.card : Colors.transparent,
              border: widget.isFollowing
                  ? null
                  : Border.all(color: AppColors.textPrimary, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.isFollowing ? 'Following' : 'Follow',
              style: AppTypography.buttonText.copyWith(fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
