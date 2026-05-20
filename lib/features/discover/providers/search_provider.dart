import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../feed/data/models/video_post.dart';
import '../data/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String>((ref) => 'Trending');

final searchResultsProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<VideoPost>>>((ref) {
      return SearchNotifier(ref.watch(searchRepositoryProvider), ref);
    });

class SearchNotifier extends StateNotifier<AsyncValue<List<VideoPost>>> {
  final SearchRepository _repository;
  final Ref _ref;

  SearchNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    _loadTrending();
  }

  Future<void> _loadTrending() async {
    state = const AsyncValue.loading();
    try {
      final posts = await _repository.getTrending();
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final posts = await _repository.search(query);
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> filterByCategory(String category) async {
    state = const AsyncValue.loading();
    try {
      final posts = await _repository.getByCategory(category);
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    final query = _ref.read(searchQueryProvider);
    if (query.isNotEmpty) {
      await search(query);
    } else {
      final category = _ref.read(selectedCategoryProvider);
      await filterByCategory(category);
    }
  }
}
