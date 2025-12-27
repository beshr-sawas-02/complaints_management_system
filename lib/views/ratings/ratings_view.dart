import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/ratings_controller.dart';
import '../../data/models/rating_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_widget.dart';

class RatingsView extends GetView<RatingsController> {
  const RatingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('التقييمات'),
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: const Icon(Iconsax.filter),
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics
          Obx(() => _buildStatistics()),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomSearchField(
              controller: controller.searchController,
              hint: 'بحث في التقييمات...',
              onChanged: controller.setSearchQuery,
              onClear: () => controller.setSearchQuery(''),
            ),
          ),

          // Filter Chips
          Obx(() => _buildFilterChips()),

          // Ratings List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.ratings.isEmpty) {
                return const LoadingWidget();
              }

              if (controller.ratings.isEmpty) {
                return EmptyWidget(
                  title: 'لا توجد تقييمات',
                  subtitle: 'لم يتم العثور على أي تقييمات',
                  icon: Iconsax.star,
                  buttonText: 'تحديث',
                  onButtonPressed: controller.refreshRatings,
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshRatings,
                color: AppColors.primary,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.ratings.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.ratings.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: LoadingWidget(size: 30)),
                      );
                    }
                    return _buildRatingCard(controller.ratings[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    final stats = controller.statistics.value;
    if (stats == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  Helpers.formatNumber(stats.totalRatings),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إجمالي التقييمات',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                    const SizedBox(width: 4),
                    Text(
                      stats.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'متوسط التقييم',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    if (controller.ratingFilter.value == null) return const SizedBox.shrink();

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Chip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text('${controller.ratingFilter.value}'),
              ],
            ),
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: () => controller.setRatingFilter(null),
            backgroundColor: AppColors.warningLight,
            labelStyle: const TextStyle(color: AppColors.warning, fontSize: 12),
            deleteIconColor: AppColors.warning,
            side: BorderSide.none,
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.clear_all, size: 18),
            label: const Text('مسح'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(RatingModel rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    (rating.userFullName ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.userFullName ?? 'مستخدم',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Helpers.timeAgo(rating.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating Stars
              _buildRatingStars(rating.rating),
            ],
          ),
          if (rating.feedback != null && rating.feedback!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              rating.feedback!,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Iconsax.message, size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(
                'شكوى: ${rating.complaintNumber ?? "غير معروف"}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  if (rating.id != null) {
                    controller.deleteRating(rating.id!);
                  }
                },
                icon: const Icon(Iconsax.trash, size: 18),
                color: AppColors.error,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: index < rating ? AppColors.warning : AppColors.textHint,
          size: 20,
        );
      }),
    );
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تصفية التقييمات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'عدد النجوم',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(5, (index) {
                final stars = index + 1;
                return Obx(() => FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 16,
                          color: controller.ratingFilter.value == stars
                              ? AppColors.warning
                              : AppColors.textHint),
                      const SizedBox(width: 4),
                      Text('$stars'),
                    ],
                  ),
                  selected: controller.ratingFilter.value == stars,
                  onSelected: (selected) {
                    controller.setRatingFilter(selected ? stars : null);
                  },
                  selectedColor: AppColors.warningLight,
                  checkmarkColor: AppColors.warning,
                  labelStyle: TextStyle(
                    color: controller.ratingFilter.value == stars
                        ? AppColors.warning
                        : AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ));
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('تطبيق'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}