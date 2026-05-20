class VideoPost {
  final String id;
  final String userId;
  final String username;
  final String avatarUrl;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final String songName;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final int viewCount;
  final bool isLiked;
  final bool isFollowing;
  final DateTime createdAt;

  const VideoPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.songName,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.viewCount,
    this.isLiked = false,
    this.isFollowing = false,
    required this.createdAt,
  });

  VideoPost copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    String? songName,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    int? viewCount,
    bool? isLiked,
    bool? isFollowing,
    DateTime? createdAt,
  }) {
    return VideoPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      songName: songName ?? this.songName,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      viewCount: viewCount ?? this.viewCount,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
