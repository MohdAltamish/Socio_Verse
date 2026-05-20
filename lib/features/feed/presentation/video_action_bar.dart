import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/video_post.dart';
import '../providers/feed_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_avatar.dart';

class VideoActionBar extends ConsumerStatefulWidget {
  final VideoPost post;

  const VideoActionBar({super.key, required this.post});

  @override
  ConsumerState<VideoActionBar> createState() => _VideoActionBarState();
}

class _VideoActionBarState extends ConsumerState<VideoActionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heartScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _onLikeTap() {
    _heartController.forward(from: 0.0);
    ref.read(feedProvider.notifier).toggleLike(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    // Re-read to get latest state
    final posts = ref.watch(feedProvider).valueOrNull ?? [];
    final post = posts.firstWhere(
      (p) => p.id == widget.post.id,
      orElse: () => widget.post,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar + Follow
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            AppAvatar(
              imageUrl: post.avatarUrl,
              size: 48,
              hasBorder: true,
              borderColor: AppColors.textPrimary,
            ),
            if (!post.isFollowing)
              Positioned(
                bottom: -8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.pink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textPrimary,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),

        // Heart
        GestureDetector(
          onTap: _onLikeTap,
          child: AnimatedBuilder(
            animation: _heartScale,
            builder: (context, child) {
              return Transform.scale(
                scale: _heartScale.value,
                child: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? AppColors.pink : AppColors.textPrimary,
                  size: 32,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(formatCount(post.likeCount), style: AppTypography.countLabel),
        const SizedBox(height: 20),

        // Comment
        GestureDetector(
          onTap: () {
            _showComments(context, post.id);
          },
          child: const Icon(
            Icons.chat_bubble_outline,
            color: AppColors.textPrimary,
            size: 32,
          ),
        ),
        const SizedBox(height: 4),
        Text(formatCount(post.commentCount), style: AppTypography.countLabel),
        const SizedBox(height: 20),

        // Share
        const Icon(
          Icons.reply,
          color: AppColors.textPrimary,
          size: 32,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 4),
        Text('Share', style: AppTypography.countLabel),
      ],
    );
  }

  void _showComments(BuildContext context, String videoId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentsSheet(videoId: videoId),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final String videoId;

  const _CommentsSheet({required this.videoId});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  // Mock comments
  final List<Map<String, dynamic>> _comments = [
    {
      'username': 'alex_creative',
      'avatar': 'https://i.pravatar.cc/150?img=20',
      'text': 'This is absolutely fire 🔥🔥',
      'time': '2h',
      'likes': 342,
      'isLiked': false,
    },
    {
      'username': 'maya_designs',
      'avatar': 'https://i.pravatar.cc/150?img=21',
      'text': 'How do you even come up with this stuff?? 😂',
      'time': '4h',
      'likes': 128,
      'isLiked': false,
    },
    {
      'username': 'ryan_codes',
      'avatar': 'https://i.pravatar.cc/150?img=22',
      'text': 'Tutorial please!! 🙏',
      'time': '6h',
      'likes': 89,
      'isLiked': false,
    },
    {
      'username': 'photo_sophie',
      'avatar': 'https://i.pravatar.cc/150?img=23',
      'text': 'The editing is chefs kiss 👨‍🍳',
      'time': '8h',
      'likes': 56,
      'isLiked': false,
    },
    {
      'username': 'dj_pulse',
      'avatar': 'https://i.pravatar.cc/150?img=24',
      'text': 'Song name?? I need it for my playlist',
      'time': '12h',
      'likes': 234,
      'isLiked': false,
    },
    {
      'username': 'skater_jake',
      'avatar': 'https://i.pravatar.cc/150?img=25',
      'text': 'Shared this with literally everyone I know',
      'time': '1d',
      'likes': 45,
      'isLiked': false,
    },
    {
      'username': 'bookworm_lily',
      'avatar': 'https://i.pravatar.cc/150?img=26',
      'text': 'This showed up on my FYP and I can\'t stop rewatching',
      'time': '1d',
      'likes': 178,
      'isLiked': false,
    },
    {
      'username': 'gamer_nova',
      'avatar': 'https://i.pravatar.cc/150?img=27',
      'text': 'POV: you found gold on your feed ✨',
      'time': '2d',
      'likes': 67,
      'isLiked': false,
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Comments (${_comments.length})',
                  style: AppTypography.headingMedium.copyWith(fontSize: 16),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.divider, height: 0.5),

          // Comments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return _CommentTile(
                  username: comment['username'] as String,
                  avatarUrl: comment['avatar'] as String,
                  text: comment['text'] as String,
                  time: comment['time'] as String,
                  likes: comment['likes'] as int,
                  isLiked: comment['isLiked'] as bool,
                  onLike: () {
                    setState(() {
                      _comments[index]['isLiked'] =
                          !(comment['isLiked'] as bool);
                      if (_comments[index]['isLiked'] as bool) {
                        _comments[index]['likes'] =
                            (comment['likes'] as int) + 1;
                      } else {
                        _comments[index]['likes'] =
                            (comment['likes'] as int) - 1;
                      }
                    });
                  },
                );
              },
            ),
          ),

          // Comment input
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
              top: 8,
              bottom: bottomInset > 0 ? bottomInset + 8 : 20,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.card,
                  child: Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        _comments.insert(0, {
                          'username': 'your_username',
                          'avatar': 'https://i.pravatar.cc/150?img=30',
                          'text': _commentController.text,
                          'time': 'now',
                          'likes': 0,
                          'isLiked': false,
                        });
                        _commentController.clear();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.send_rounded,
                      color: AppColors.pink,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String text;
  final String time;
  final int likes;
  final bool isLiked;
  final VoidCallback onLike;

  const _CommentTile({
    required this.username,
    required this.avatarUrl,
    required this.text,
    required this.time,
    required this.likes,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.card,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(text, style: AppTypography.bodyMedium),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      time,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onLike,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? AppColors.pink : AppColors.textTertiary,
                  size: 16,
                ),
                const SizedBox(height: 2),
                Text(
                  likes.toString(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
