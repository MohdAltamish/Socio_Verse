import '../../feed/data/models/video_post.dart';
import '../../feed/data/feed_repository.dart';

class SearchRepository {
  final MockFeedRepository _feedRepository = MockFeedRepository();

  static const List<String> categories = [
    'Trending',
    'Music',
    'Food',
    'Travel',
    'Dance',
    'Fitness',
    'Art',
    'Comedy',
    'Tech',
    'Pets',
    'Nature',
  ];

  Future<List<VideoPost>> search(String query) async {
    return _feedRepository.searchPosts(query);
  }

  Future<List<VideoPost>> getByCategory(String category) async {
    return _feedRepository.getPostsByCategory(category);
  }

  Future<List<VideoPost>> getTrending() async {
    return _feedRepository.getTrendingPosts();
  }
}
