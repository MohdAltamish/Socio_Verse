import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/follow_button.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({super.key, this.userId = 'me'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider(userId));
    final activeTab = ref.watch(profileTabProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: profileState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.pink),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Failed to load profile', style: AppTypography.bodyLarge),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () =>
                      ref.read(profileProvider(userId).notifier).loadProfile(),
                  child: Text(
                    'Retry',
                    style: AppTypography.buttonText.copyWith(
                      color: AppColors.pink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (user) => CustomScrollView(
            slivers: [
              // App bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                      const Spacer(),
                      Text(
                        '@${user.username}',
                        style: AppTypography.headingMedium.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.more_horiz,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),

              // Avatar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: AppAvatar(imageUrl: user.avatarUrl, size: 80),
                  ),
                ),
              ),

              // Username
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      '@${user.username}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // Stats row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatColumn(
                        count: formatCount(user.followingCount),
                        label: 'Following',
                      ),
                      _StatDivider(),
                      _StatColumn(
                        count: formatCount(user.followersCount),
                        label: 'Followers',
                      ),
                      _StatDivider(),
                      _StatColumn(
                        count: formatCount(user.likeCount),
                        label: 'Likes',
                      ),
                    ],
                  ),
                ),
              ),

              // Edit Profile / Follow button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: userId == 'me'
                        ? GestureDetector(
                            onTap: () => context.push('/edit_profile'),
                            child: Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Edit Profile',
                                style: AppTypography.buttonText,
                              ),
                            ),
                          )
                        : FollowButton(
                            isFollowing: user.isFollowing,
                            onToggle: () => ref
                                .read(profileProvider(userId).notifier)
                                .toggleFollow(),
                          ),
                  ),
                ),
              ),

              // Bio
              if (user.bio.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 12, 32, 0),
                    child: Center(
                      child: Text(
                        user.bio,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

              // Tab bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.divider,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        _ProfileTab(
                          icon: Icons.grid_on,
                          isActive: activeTab == 0,
                          onTap: () =>
                              ref.read(profileTabProvider.notifier).state = 0,
                        ),
                        _ProfileTab(
                          icon: Icons.favorite_border,
                          isActive: activeTab == 1,
                          onTap: () =>
                              ref.read(profileTabProvider.notifier).state = 1,
                        ),
                        _ProfileTab(
                          icon: Icons.lock_outline,
                          isActive: activeTab == 2,
                          onTap: () =>
                              ref.read(profileTabProvider.notifier).state = 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Video grid
              if (activeTab == 0)
                SliverPadding(
                  padding: const EdgeInsets.only(top: 2, bottom: 80),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 3 / 4,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index >= user.posts.length) return null;
                      final post = user.posts[index];
                      return _VideoGridItem(
                        thumbnailUrl: post.thumbnailUrl,
                        viewCount: post.viewCount,
                      );
                    }, childCount: user.posts.length),
                  ),
                ),

              // Liked tab placeholder
              if (activeTab == 1)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite_border,
                          color: AppColors.textTertiary,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Liked videos',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Private tab placeholder
              if (activeTab == 2)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: AppColors.textTertiary,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Private videos',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String count;
  final String label;

  const _StatColumn({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            count,
            style: AppTypography.headingMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 20, color: AppColors.divider);
  }
}

class _ProfileTab extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ProfileTab({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.pink : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _VideoGridItem extends StatelessWidget {
  final String thumbnailUrl;
  final int viewCount;

  const _VideoGridItem({required this.thumbnailUrl, required this.viewCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: thumbnailUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.card),
          errorWidget: (_, __, ___) => Container(
            color: AppColors.card,
            child: const Icon(
              Icons.video_library,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
        ),
        // View count
        Positioned(
          bottom: 4,
          left: 4,
          child: Row(
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.textPrimary,
                size: 14,
              ),
              const SizedBox(width: 2),
              Text(
                formatCount(viewCount),
                style: AppTypography.countLabel.copyWith(
                  fontSize: 11,
                  shadows: [
                    const Shadow(blurRadius: 4, color: AppColors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
