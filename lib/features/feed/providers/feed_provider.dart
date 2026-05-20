import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/feed_repository.dart';
import '../data/models/video_post.dart';

final feedRepositoryProvider = Provider<MockFeedRepository>((ref) {
  return MockFeedRepository();
});

final feedProvider =
    StateNotifierProvider<FeedNotifier, AsyncValue<List<VideoPost>>>((ref) {
      return FeedNotifier(ref.watch(feedRepositoryProvider));
    });

final activeTabIndexProvider = StateProvider<int>(
  (ref) => 1,
); // "For You" default

class FeedNotifier extends StateNotifier<AsyncValue<List<VideoPost>>> {
  final MockFeedRepository _repository;
  int _page = 0;

  FeedNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = const AsyncValue.loading();
    try {
      final posts = await _repository.getFeedPosts();
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull ?? [];
    try {
      _page++;
      final more = await _repository.getMorePosts(_page);
      state = AsyncValue.data([...current, ...more]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addPost(VideoPost post) {
    _repository.addPost(post);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([post, ...current]);
  }

  void toggleLike(String videoId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
      current.map((post) {
        if (post.id == videoId) {
          return post.copyWith(
            isLiked: !post.isLiked,
            likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
          );
        }
        return post;
      }).toList(),
    );
  }

  void toggleFollow(String userId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
      current.map((post) {
        if (post.userId == userId) {
          return post.copyWith(isFollowing: !post.isFollowing);
        }
        return post;
      }).toList(),
    );
  }
}
