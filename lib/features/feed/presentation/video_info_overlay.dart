import 'package:flutter/material.dart';
import '../data/models/video_post.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class VideoInfoOverlay extends StatefulWidget {
  final VideoPost post;

  const VideoInfoOverlay({super.key, required this.post});

  @override
  State<VideoInfoOverlay> createState() => _VideoInfoOverlayState();
}

class _VideoInfoOverlayState extends State<VideoInfoOverlay> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Username
        Text(
          '@${widget.post.username}',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        // Caption
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            widget.post.caption,
            style: AppTypography.bodyMedium,
            maxLines: _expanded ? null : 2,
            overflow: _expanded ? null : TextOverflow.ellipsis,
          ),
        ),

        if (!_expanded && widget.post.caption.length > 80) ...[
          const SizedBox(height: 2),
          GestureDetector(
            onTap: () => setState(() => _expanded = true),
            child: Text(
              'Read more',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],

        const SizedBox(height: 12),

        // Song marquee
        Row(
          children: [
            const Icon(
              Icons.music_note,
              color: AppColors.textPrimary,
              size: 14,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: SizedBox(
                height: 18,
                child: _MarqueeText(text: widget.post.songName),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MarqueeText extends StatefulWidget {
  final String text;

  const _MarqueeText({required this.text});

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _animation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: const Offset(-1.0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SlideTransition(
        position: _animation,
        child: Text(
          '${widget.text}     ${widget.text}',
          style: AppTypography.bodyMedium.copyWith(fontSize: 13),
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }
}
