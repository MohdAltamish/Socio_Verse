import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../providers/feed_provider.dart';
import '../data/models/video_post.dart';
import 'video_action_bar.dart';
import 'video_info_overlay.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);
    final activeTab = ref.watch(activeTabIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Video feed
          feedState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            ),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Something went wrong', style: AppTypography.bodyLarge),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => ref.read(feedProvider.notifier).loadFeed(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textSecondary),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Retry', style: AppTypography.buttonText),
                    ),
                  ),
                ],
              ),
            ),
            data: (posts) => PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              itemCount: posts.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                // Load more when near end
                if (index >= posts.length - 3) {
                  ref.read(feedProvider.notifier).loadMore();
                }
              },
              itemBuilder: (context, index) {
                return _VideoPage(
                  post: posts[index],
                  isActive: index == _currentPage,
                );
              },
            ),
          ),

          // Top Tab Bar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TabButton(
                    label: 'Following',
                    isActive: activeTab == 0,
                    onTap: () =>
                        ref.read(activeTabIndexProvider.notifier).state = 0,
                  ),
                  const SizedBox(width: 20),
                  _TabButton(
                    label: 'For You',
                    isActive: activeTab == 1,
                    onTap: () =>
                        ref.read(activeTabIndexProvider.notifier).state = 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 6 : 0,
            height: isActive ? 6 : 0,
            decoration: const BoxDecoration(
              color: AppColors.pink,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPage extends ConsumerStatefulWidget {
  final VideoPost post;
  final bool isActive;

  const _VideoPage({required this.post, required this.isActive});

  @override
  ConsumerState<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<_VideoPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showPlayIcon = false;
  bool _showHeart = false;
  Offset _heartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final videoUrl = widget.post.videoUrl;
    if (kIsWeb || videoUrl.startsWith('http') || videoUrl.startsWith('blob:')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    } else {
      _controller = VideoPlayerController.file(File(videoUrl));
    }
    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(1.0);
      if (widget.isActive) {
        _controller.play();
      }
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (_) {
      // Video init failed silently — shows placeholder
    }
  }

  @override
  void didUpdateWidget(_VideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _showPlayIcon = true);
    } else {
      _controller.play();
      setState(() => _showPlayIcon = false);
    }
  }

  void _onDoubleTap(TapDownDetails details) {
    setState(() {
      _heartPosition = details.localPosition;
      _showHeart = true;
    });

    final post = widget.post;
    if (!post.isLiked) {
      ref.read(feedProvider.notifier).toggleLike(post.id);
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showHeart = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      onDoubleTapDown: _onDoubleTap,
      onDoubleTap: () {},
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video or placeholder
          if (_isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Container(
              color: AppColors.surface,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.pink,
                  strokeWidth: 2,
                ),
              ),
            ),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bottomGradientStart,
                    AppColors.bottomGradientEnd,
                  ],
                ),
              ),
            ),
          ),

          // Video info overlay (bottom-left)
          Positioned(
            bottom: 80,
            left: 16,
            right: 80,
            child: VideoInfoOverlay(post: widget.post),
          ),

          // Action sidebar (right)
          Positioned(
            right: 12,
            bottom: 100,
            child: VideoActionBar(post: widget.post),
          ),

          // Play/Pause icon
          if (_showPlayIcon)
            Center(
              child: AnimatedOpacity(
                opacity: _showPlayIcon ? 0.7 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.textPrimary,
                  size: 72,
                ),
              ),
            ),

          // Double-tap heart animation
          if (_showHeart)
            Positioned(
              left: _heartPosition.dx - 40,
              top: _heartPosition.dy - 40,
              child: _HeartAnimation(),
            ),
        ],
      ),
    );
  }
}

class _HeartAnimation extends StatefulWidget {
  @override
  State<_HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<_HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 40),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: const Icon(Icons.favorite, color: AppColors.pink, size: 80),
          ),
        );
      },
    );
  }
}
