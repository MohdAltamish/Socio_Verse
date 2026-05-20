import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../feed/data/models/video_post.dart';
import '../../profile/data/user_model.dart';
import '../data/notification_model.dart';

final inboxProvider =
    StateNotifierProvider<InboxNotifier, AsyncValue<List<NotificationItem>>>((
      ref,
    ) {
      return InboxNotifier();
    });

final inboxTabProvider = StateProvider<int>((ref) => 0);

class InboxNotifier extends StateNotifier<AsyncValue<List<NotificationItem>>> {
  InboxNotifier() : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  static const _avatarBase = 'https://i.pravatar.cc/150?img=';
  static const _thumbnailBase = 'https://picsum.photos/seed/';

  Future<void> loadNotifications() async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final notifications = [
        NotificationItem(
          id: 'n1',
          type: NotificationType.follow,
          fromUser: UserModel(
            id: 'u20',
            username: 'alex_creative',
            avatarUrl: '${_avatarBase}20',
            bio: '',
            followingCount: 120,
            followersCount: 8400,
            likeCount: 45000,
          ),
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        NotificationItem(
          id: 'n2',
          type: NotificationType.like,
          fromUser: UserModel(
            id: 'u21',
            username: 'maya_designs',
            avatarUrl: '${_avatarBase}21',
            bio: '',
            followingCount: 89,
            followersCount: 12300,
            likeCount: 67000,
          ),
          relatedVideo: VideoPost(
            id: 'v1',
            userId: 'me',
            username: 'me',
            avatarUrl: '',
            videoUrl: '',
            thumbnailUrl: '${_thumbnailBase}n2/100/140',
            caption: '',
            songName: '',
            likeCount: 0,
            commentCount: 0,
            shareCount: 0,
            viewCount: 0,
            createdAt: DateTime.now(),
          ),
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        NotificationItem(
          id: 'n3',
          type: NotificationType.comment,
          fromUser: UserModel(
            id: 'u22',
            username: 'ryan_codes',
            avatarUrl: '${_avatarBase}22',
            bio: '',
            followingCount: 200,
            followersCount: 5600,
            likeCount: 23000,
          ),
          relatedVideo: VideoPost(
            id: 'v1',
            userId: 'me',
            username: 'me',
            avatarUrl: '',
            videoUrl: '',
            thumbnailUrl: '${_thumbnailBase}n3/100/140',
            caption: '',
            songName: '',
            likeCount: 0,
            commentCount: 0,
            shareCount: 0,
            viewCount: 0,
            createdAt: DateTime.now(),
          ),
          commentText: 'This is absolutely insane 🔥',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        NotificationItem(
          id: 'n4',
          type: NotificationType.follow,
          fromUser: UserModel(
            id: 'u23',
            username: 'photo_sophie',
            avatarUrl: '${_avatarBase}23',
            bio: '',
            followingCount: 340,
            followersCount: 18200,
            likeCount: 91000,
          ),
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        NotificationItem(
          id: 'n5',
          type: NotificationType.mention,
          fromUser: UserModel(
            id: 'u24',
            username: 'dj_pulse',
            avatarUrl: '${_avatarBase}24',
            bio: '',
            followingCount: 150,
            followersCount: 42000,
            likeCount: 210000,
          ),
          commentText: '@you need to see this collab idea',
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        NotificationItem(
          id: 'n6',
          type: NotificationType.like,
          fromUser: UserModel(
            id: 'u25',
            username: 'skater_jake',
            avatarUrl: '${_avatarBase}25',
            bio: '',
            followingCount: 67,
            followersCount: 3400,
            likeCount: 15000,
          ),
          relatedVideo: VideoPost(
            id: 'v2',
            userId: 'me',
            username: 'me',
            avatarUrl: '',
            videoUrl: '',
            thumbnailUrl: '${_thumbnailBase}n6/100/140',
            caption: '',
            songName: '',
            likeCount: 0,
            commentCount: 0,
            shareCount: 0,
            viewCount: 0,
            createdAt: DateTime.now(),
          ),
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationItem(
          id: 'n7',
          type: NotificationType.comment,
          fromUser: UserModel(
            id: 'u26',
            username: 'bookworm_lily',
            avatarUrl: '${_avatarBase}26',
            bio: '',
            followingCount: 230,
            followersCount: 9800,
            likeCount: 54000,
          ),
          relatedVideo: VideoPost(
            id: 'v2',
            userId: 'me',
            username: 'me',
            avatarUrl: '',
            videoUrl: '',
            thumbnailUrl: '${_thumbnailBase}n7/100/140',
            caption: '',
            songName: '',
            likeCount: 0,
            commentCount: 0,
            shareCount: 0,
            viewCount: 0,
            createdAt: DateTime.now(),
          ),
          commentText: 'How did you edit this?? Tutorial please!',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NotificationItem(
          id: 'n8',
          type: NotificationType.follow,
          fromUser: UserModel(
            id: 'u27',
            username: 'gamer_nova',
            avatarUrl: '${_avatarBase}27',
            bio: '',
            followingCount: 410,
            followersCount: 27000,
            likeCount: 130000,
          ),
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
