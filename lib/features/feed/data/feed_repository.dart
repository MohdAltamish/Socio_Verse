import 'models/video_post.dart';

class MockFeedRepository {
  static const _avatarBase = 'https://i.pravatar.cc/150?img=';
  static const _thumbnailBase = 'https://picsum.photos/seed/';

  // Using reliable public sample videos
  static const List<String> _sampleVideoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://www.w3schools.com/html/mov_bbb.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://www.w3schools.com/html/mov_bbb.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://www.w3schools.com/html/mov_bbb.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  final List<VideoPost> _mockPosts = [
    VideoPost(
      id: 'v1',
      userId: 'u1',
      username: 'sarah_vibes',
      avatarUrl: '${_avatarBase}1',
      videoUrl: _sampleVideoUrls[0],
      thumbnailUrl: '${_thumbnailBase}sv1/400/700',
      caption: 'Just vibing on a Sunday afternoon ✨ #chill #vibes #weekend',
      songName: 'Blinding Lights - The Weeknd',
      likeCount: 38200,
      commentCount: 8600,
      shareCount: 1200,
      viewCount: 846000,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    VideoPost(
      id: 'v2',
      userId: 'u2',
      username: 'chef_marco',
      avatarUrl: '${_avatarBase}3',
      videoUrl: _sampleVideoUrls[1],
      thumbnailUrl: '${_thumbnailBase}sv2/400/700',
      caption: 'Quick 60-second pasta recipe you NEED to try 🍝',
      songName: 'original sound - chef_marco',
      likeCount: 124500,
      commentCount: 3400,
      shareCount: 8900,
      viewCount: 2100000,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    VideoPost(
      id: 'v3',
      userId: 'u3',
      username: 'traveljess',
      avatarUrl: '${_avatarBase}5',
      videoUrl: _sampleVideoUrls[2],
      thumbnailUrl: '${_thumbnailBase}sv3/400/700',
      caption: 'Found this hidden gem in Bali 🌴 save for later!',
      songName: 'Sunflower - Post Malone',
      likeCount: 89300,
      commentCount: 5100,
      shareCount: 12400,
      viewCount: 1500000,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    VideoPost(
      id: 'v4',
      userId: 'u4',
      username: 'mike_dance',
      avatarUrl: '${_avatarBase}7',
      videoUrl: _sampleVideoUrls[3],
      thumbnailUrl: '${_thumbnailBase}sv4/400/700',
      caption: 'New choreo alert 🔥 Tutorial coming soon #dance #tutorial',
      songName: 'Levitating - Dua Lipa',
      likeCount: 256800,
      commentCount: 14200,
      shareCount: 32100,
      viewCount: 5200000,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    VideoPost(
      id: 'v5',
      userId: 'u5',
      username: 'fitfiona',
      avatarUrl: '${_avatarBase}9',
      videoUrl: _sampleVideoUrls[4],
      thumbnailUrl: '${_thumbnailBase}sv5/400/700',
      caption: '5-min morning workout to wake up your body 💪',
      songName: 'Eye of the Tiger - Survivor',
      likeCount: 67400,
      commentCount: 2800,
      shareCount: 9500,
      viewCount: 980000,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    VideoPost(
      id: 'v6',
      userId: 'u6',
      username: 'artsy_anna',
      avatarUrl: '${_avatarBase}11',
      videoUrl: _sampleVideoUrls[5],
      thumbnailUrl: '${_thumbnailBase}sv6/400/700',
      caption: 'Painting the sunset from my balcony 🎨 #art #satisfying',
      songName: 'Lo-fi Study Beats',
      likeCount: 45200,
      commentCount: 1900,
      shareCount: 6700,
      viewCount: 720000,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
    ),
    VideoPost(
      id: 'v7',
      userId: 'u7',
      username: 'comedy_king',
      avatarUrl: '${_avatarBase}13',
      videoUrl: _sampleVideoUrls[6],
      thumbnailUrl: '${_thumbnailBase}sv7/400/700',
      caption: 'POV: You tell your mom you\'re not hungry 😂',
      songName: 'original sound - comedy_king',
      likeCount: 512000,
      commentCount: 28400,
      shareCount: 45000,
      viewCount: 8900000,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    VideoPost(
      id: 'v8',
      userId: 'u8',
      username: 'tech_sam',
      avatarUrl: '${_avatarBase}15',
      videoUrl: _sampleVideoUrls[7],
      thumbnailUrl: '${_thumbnailBase}sv8/400/700',
      caption: 'iPhone hack you didn\'t know existed 📱 #tech #lifehack',
      songName: 'Aesthetic - Tollan Kim',
      likeCount: 183000,
      commentCount: 9200,
      shareCount: 27000,
      viewCount: 3400000,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
    ),
    VideoPost(
      id: 'v9',
      userId: 'u9',
      username: 'pet_paradise',
      avatarUrl: '${_avatarBase}17',
      videoUrl: _sampleVideoUrls[8],
      thumbnailUrl: '${_thumbnailBase}sv9/400/700',
      caption: 'My golden retriever learning tricks 🐕 part 3',
      songName: 'Happy - Pharrell Williams',
      likeCount: 342000,
      commentCount: 16800,
      shareCount: 38000,
      viewCount: 6100000,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    VideoPost(
      id: 'v10',
      userId: 'u10',
      username: 'nature_nick',
      avatarUrl: '${_avatarBase}19',
      videoUrl: _sampleVideoUrls[9],
      thumbnailUrl: '${_thumbnailBase}sv10/400/700',
      caption: 'Caught the northern lights on camera ✨ #nature #aurora',
      songName: 'Stargazing - Kygo',
      likeCount: 198500,
      commentCount: 7600,
      shareCount: 21000,
      viewCount: 4200000,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  void addPost(VideoPost post) {
    _mockPosts.insert(0, post);
  }

  Future<List<VideoPost>> getFeedPosts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_mockPosts);
  }

  Future<List<VideoPost>> getMorePosts(int page) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Return the same posts with modified IDs for pagination simulation
    return _mockPosts.map((post) {
      return post.copyWith(id: '${post.id}_p$page');
    }).toList();
  }

  Future<List<VideoPost>> getTrendingPosts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_mockPosts)..shuffle();
  }

  Future<List<VideoPost>> searchPosts(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.isEmpty) return List.from(_mockPosts);
    final lower = query.toLowerCase();
    return _mockPosts.where((post) {
      return post.caption.toLowerCase().contains(lower) ||
          post.username.toLowerCase().contains(lower) ||
          post.songName.toLowerCase().contains(lower);
    }).toList();
  }

  Future<List<VideoPost>> getPostsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulate category filtering
    final categoryMap = <String, List<int>>{
      'Trending': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      'Music': [0, 3, 9],
      'Food': [1],
      'Travel': [2],
      'Dance': [3],
      'Fitness': [4],
      'Art': [5],
      'Comedy': [6],
      'Tech': [7],
      'Pets': [8],
      'Nature': [9],
    };
    final indices = categoryMap[category] ?? [0, 1, 2, 3, 4];
    return indices
        .where((i) => i < _mockPosts.length)
        .map((i) => _mockPosts[i])
        .toList();
  }

  Future<List<VideoPost>> getUserPosts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockPosts.where((post) => post.userId == userId).toList();
  }
}
