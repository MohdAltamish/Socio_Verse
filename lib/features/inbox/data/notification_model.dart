import '../../profile/data/user_model.dart';
import '../../feed/data/models/video_post.dart';

enum NotificationType { follow, like, comment, mention }

class NotificationItem {
  final String id;
  final NotificationType type;
  final UserModel fromUser;
  final VideoPost? relatedVideo;
  final String? commentText;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.fromUser,
    this.relatedVideo,
    this.commentText,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    NotificationType? type,
    UserModel? fromUser,
    VideoPost? relatedVideo,
    String? commentText,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      fromUser: fromUser ?? this.fromUser,
      relatedVideo: relatedVideo ?? this.relatedVideo,
      commentText: commentText ?? this.commentText,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
