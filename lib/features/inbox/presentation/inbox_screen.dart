import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/inbox_provider.dart';
import '../data/notification_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_avatar.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxState = ref.watch(inboxProvider);
    final activeTab = ref.watch(inboxTabProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Inbox',
                    style: AppTypography.displayLarge.copyWith(fontSize: 24),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.send_outlined,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _InboxTab(
                    label: 'All Activity',
                    isActive: activeTab == 0,
                    onTap: () => ref.read(inboxTabProvider.notifier).state = 0,
                  ),
                  const SizedBox(width: 24),
                  _InboxTab(
                    label: 'Mentions',
                    isActive: activeTab == 1,
                    onTap: () => ref.read(inboxTabProvider.notifier).state = 1,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Notification list
            Expanded(
              child: inboxState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.pink),
                ),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load notifications',
                        style: AppTypography.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => ref
                            .read(inboxProvider.notifier)
                            .loadNotifications(),
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
                data: (notifications) {
                  final filtered = activeTab == 1
                      ? notifications
                            .where((n) => n.type == NotificationType.mention)
                            .toList()
                      : notifications;

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No notifications yet',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _NotificationTile(notification: filtered[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InboxTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _InboxTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? 40 : 0,
            color: AppColors.pink,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationTile({required this.notification});

  String get _actionText {
    switch (notification.type) {
      case NotificationType.follow:
        return 'started following you';
      case NotificationType.like:
        return 'liked your video';
      case NotificationType.comment:
        return 'commented: ${notification.commentText ?? ''}';
      case NotificationType.mention:
        return 'mentioned you in a comment';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          AppAvatar(imageUrl: notification.fromUser.avatarUrl, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: notification.fromUser.username,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: _actionText,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeAgo(notification.timestamp),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
              if (notification.type == NotificationType.follow)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Follow',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (notification.relatedVideo != null) ...[
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: notification.relatedVideo!.thumbnailUrl,
                width: 48,
                height: 64,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(width: 48, height: 64, color: AppColors.card),
                errorWidget: (_, __, ___) => Container(
                  width: 48,
                  height: 64,
                  color: AppColors.card,
                  child: const Icon(
                    Icons.video_library,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
