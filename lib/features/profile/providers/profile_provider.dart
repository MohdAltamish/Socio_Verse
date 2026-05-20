import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../feed/data/feed_repository.dart';
import '../data/user_model.dart';

final profileProvider =
    StateNotifierProvider.family<
      ProfileNotifier,
      AsyncValue<UserModel>,
      String
    >((ref, userId) {
      return ProfileNotifier(userId, ref.watch(profileRepositoryProvider));
    });

final profileRepositoryProvider = Provider<MockFeedRepository>((ref) {
  return MockFeedRepository();
});

final profileTabProvider = StateProvider<int>((ref) => 0);

class ProfileNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final String userId;
  final MockFeedRepository _repository;

  ProfileNotifier(this.userId, this._repository)
    : super(const AsyncValue.loading()) {
    loadProfile();
  }

  static const _avatarBase = 'https://i.pravatar.cc/150?img=';

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Get user posts from repo
      final posts = await _repository.getFeedPosts();

      final box = await Hive.openBox('settings');

      final user = userId == 'me'
          ? UserModel(
              id: 'me',
              username: box.get('username', defaultValue: 'your_username'),
              avatarUrl: '${_avatarBase}30',
              bio: box.get(
                'bio',
                defaultValue:
                    '✨ Creating content since 2024\n📍 New York City\n🎬 Let\'s collaborate!',
              ),
              followingCount: 342,
              followersCount: 846200,
              likeCount: 12400000,
              posts: posts,
            )
          : UserModel(
              id: userId,
              username:
                  posts
                      .where((p) => p.userId == userId)
                      .firstOrNull
                      ?.username ??
                  'user_$userId',
              avatarUrl:
                  posts
                      .where((p) => p.userId == userId)
                      .firstOrNull
                      ?.avatarUrl ??
                  '${_avatarBase}30',
              bio: 'Just living my best life ✌️',
              followingCount: 156,
              followersCount: 24500,
              likeCount: 890000,
              posts: posts.where((p) => p.userId == userId).toList(),
            );

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(String newUsername, String newBio) async {
    final box = await Hive.openBox('settings');
    await box.put('username', newUsername);
    await box.put('bio', newBio);

    final current = state.valueOrNull;
    if (current != null && current.id == 'me') {
      state = AsyncValue.data(
        current.copyWith(username: newUsername, bio: newBio),
      );
    }
  }

  void toggleFollow() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        isFollowing: !current.isFollowing,
        followersCount: current.isFollowing
            ? current.followersCount - 1
            : current.followersCount + 1,
      ),
    );
  }
}
