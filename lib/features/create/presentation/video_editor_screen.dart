import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../feed/providers/feed_provider.dart';
import '../../feed/data/models/video_post.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class VideoEditorScreen extends ConsumerStatefulWidget {
  final String videoPath;

  const VideoEditorScreen({super.key, required this.videoPath});

  @override
  ConsumerState<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends ConsumerState<VideoEditorScreen> {
  late VideoPlayerController _controller;
  final TextEditingController _captionController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (kIsWeb ||
        widget.videoPath.startsWith('http') ||
        widget.videoPath.startsWith('blob:')) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoPath),
      );
    } else {
      _controller = VideoPlayerController.file(File(widget.videoPath));
    }

    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video in editor: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _postVideo() {
    final caption = _captionController.text.trim();
    final newPost = VideoPost(
      id: const Uuid().v4(),
      userId: 'me',
      username: 'my_awesome_profile',
      avatarUrl:
          'https://i.pravatar.cc/150?img=12', // A mock avatar for the current user
      videoUrl: widget.videoPath,
      thumbnailUrl:
          'https://picsum.photos/seed/${const Uuid().v4()}/400/700', // Mock thumbnail
      caption: caption.isEmpty ? 'My new video! 🚀' : caption,
      songName: 'original sound - me',
      likeCount: 0,
      commentCount: 0,
      shareCount: 0,
      viewCount: 0,
      createdAt: DateTime.now(),
    );

    ref.read(feedProvider.notifier).addPost(newPost);
    // Go back to the feed screen
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Video background
          if (_isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GestureDetector(
                      onTap: _postVideo,
                      child: Text(
                        'Next',
                        style: AppTypography.buttonText.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Caption Input at Bottom
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _captionController,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Describe your video...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
