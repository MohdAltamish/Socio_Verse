import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/search_provider.dart';
import '../data/search_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/debouncer.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 400);

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: AppTypography.bodyMedium,
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                      _debouncer.run(() {
                        if (value.isNotEmpty) {
                          ref
                              .read(searchResultsProvider.notifier)
                              .search(value);
                        } else {
                          ref
                              .read(searchResultsProvider.notifier)
                              .filterByCategory(selectedCategory);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: SearchRepository.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = SearchRepository.categories[index];
                    final isSelected = selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                        ref
                            .read(searchResultsProvider.notifier)
                            .filterByCategory(category);
                      },
                      child: Chip(
                        label: Text(category),
                        backgroundColor: isSelected
                            ? AppColors.pink
                            : AppColors.card,
                        labelStyle: AppTypography.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Video grid
            searchResults.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.pink),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Something went wrong',
                        style: AppTypography.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () =>
                            ref.read(searchResultsProvider.notifier).refresh(),
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
              ),
              data: (posts) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3 / 4,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = posts[index];
                    return _GridItem(
                      thumbnailUrl: post.thumbnailUrl,
                      viewCount: post.viewCount,
                    );
                  }, childCount: posts.length),
                ),
              ),
            ),

            // Bottom padding for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String thumbnailUrl;
  final int viewCount;

  const _GridItem({required this.thumbnailUrl, required this.viewCount});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.card),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.card,
              child: const Icon(
                Icons.video_library,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Play icon overlay
          const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: AppColors.textPrimary,
              size: 40,
            ),
          ),
          // View count chip
          Positioned(
            bottom: 8,
            left: 8,
            child: Row(
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.textPrimary,
                  size: 14,
                ),
                const SizedBox(width: 2),
                Text(
                  formatCount(viewCount),
                  style: AppTypography.countLabel.copyWith(
                    fontSize: 11,
                    shadows: [
                      const Shadow(blurRadius: 4, color: AppColors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
