import '../../feed/data/models/video_post.dart';

class UserModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String bio;
  final int followingCount;
  final int followersCount;
  final int likeCount;
  final List<VideoPost> posts;
  final bool isFollowing;

  const UserModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.bio,
    required this.followingCount,
    required this.followersCount,
    required this.likeCount,
    this.posts = const [],
    this.isFollowing = false,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    String? bio,
    int? followingCount,
    int? followersCount,
    int? likeCount,
    List<VideoPost>? posts,
    bool? isFollowing,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      likeCount: likeCount ?? this.likeCount,
      posts: posts ?? this.posts,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
