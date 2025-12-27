import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/rating_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/rating_repository.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class RatingsController extends GetxController {
  final RatingRepository _repository = RatingRepository();

  // Data
  final RxList<RatingModel> ratings = <RatingModel>[].obs;
  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
  final Rx<RatingStatistics?> statistics = Rx<RatingStatistics?>(null);

  // Filters
  final RxString searchQuery = ''.obs;
  final Rxn<int> ratingFilter = Rxn<int>();
  final RxInt currentPage = 1.obs;

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isRefreshing = false.obs;

  // Scroll Controller
  final ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadRatings();
    loadStatistics();
    _setupScrollListener();

    debounce(searchQuery, (_) => _onSearchChanged(),
        time: Constants.debounceDuration);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreRatings();
      }
    });
  }

  void _onSearchChanged() {
    currentPage.value = 1;
    loadRatings();
  }

  Future<void> loadRatings() async {
    try {
      isLoading.value = true;

      final response = await _repository.getRatings(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        rating: ratingFilter.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      ratings.value = response.ratings;
      pagination.value = response.pagination;
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreRatings() async {
    if (isLoadingMore.value) return;
    if (pagination.value == null || !pagination.value!.hasNextPage) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await _repository.getRatings(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        rating: ratingFilter.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      ratings.addAll(response.ratings);
      pagination.value = response.pagination;
    } catch (e) {
      currentPage.value--;
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshRatings() async {
    try {
      isRefreshing.value = true;
      currentPage.value = 1;
      await loadRatings();
      await loadStatistics();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> loadStatistics() async {
    try {
      statistics.value = await _repository.getStatistics();
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> deleteRating(String id) async {
    final confirm = await Helpers.showConfirmDialog(
      title: 'حذف التقييم',
      message: 'هل أنت متأكد من حذف هذا التقييم؟',
      confirmText: 'حذف',
    );

    if (confirm != true) return;

    try {
      await _repository.deleteRating(id);
      ratings.removeWhere((r) => r.id == id);
      Helpers.showSuccessSnackbar('تم حذف التقييم');
      await loadStatistics();
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    }
  }

  void setRatingFilter(int? rating) {
    ratingFilter.value = rating;
    currentPage.value = 1;
    loadRatings();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    ratingFilter.value = null;
    currentPage.value = 1;
    loadRatings();
  }

  // Getters for statistics
  int get totalRatings => statistics.value?.totalRatings ?? 0;
  double get averageRating => statistics.value?.averageRating ?? 0.0;
}