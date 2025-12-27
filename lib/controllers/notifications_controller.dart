// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../data/models/notification_model.dart';
// import '../data/models/user_model.dart';
// import '../data/repositories/notification_repository.dart';
// import '../utils/helpers.dart';
// import '../utils/constants.dart';
//
// class NotificationsController extends GetxController {
//   final NotificationRepository _repository = NotificationRepository();
//
//   // Data
//   final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
//   final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
//   final Rx<NotificationStatistics?> statistics = Rx<NotificationStatistics?>(null);
//
//   // Filters
//   final RxString searchQuery = ''.obs;
//   final Rxn<String> typeFilter = Rxn<String>();
//   final RxInt currentPage = 1.obs;
//
//   // Loading States
//   final RxBool isLoading = false.obs;
//   final RxBool isLoadingMore = false.obs;
//   final RxBool isRefreshing = false.obs;
//
//   // Scroll Controller
//   final ScrollController scrollController = ScrollController();
//   final searchController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadNotifications();
//     loadStatistics();
//     _setupScrollListener();
//
//     debounce(searchQuery, (_) => _onSearchChanged(),
//         time: Constants.debounceDuration);
//   }
//
//   @override
//   void onClose() {
//     searchController.dispose();
//     scrollController.dispose();
//     super.onClose();
//   }
//
//   void _setupScrollListener() {
//     scrollController.addListener(() {
//       if (scrollController.position.pixels >=
//           scrollController.position.maxScrollExtent - 200) {
//         loadMoreNotifications();
//       }
//     });
//   }
//
//   void _onSearchChanged() {
//     currentPage.value = 1;
//     loadNotifications();
//   }
//
//   Future<void> loadNotifications() async {
//     try {
//       isLoading.value = true;
//
//       // ✅ استخدام getMyNotifications بدلاً من getNotifications
//       final response = await _repository.getMyNotifications(
//         type: typeFilter.value,
//         page: currentPage.value,
//         limit: Constants.defaultPageSize,
//       );
//
//       notifications.value = response.notifications;
//       pagination.value = response.pagination;
//     } catch (e) {
//       Helpers.showErrorSnackbar(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> loadMoreNotifications() async {
//     if (isLoadingMore.value) return;
//     if (pagination.value == null || !pagination.value!.hasNextPage) return;
//
//     try {
//       isLoadingMore.value = true;
//       currentPage.value++;
//
//       // ✅ استخدام getMyNotifications بدلاً من getNotifications
//       final response = await _repository.getMyNotifications(
//         type: typeFilter.value,
//         page: currentPage.value,
//         limit: Constants.defaultPageSize,
//       );
//
//       notifications.addAll(response.notifications);
//       pagination.value = response.pagination;
//     } catch (e) {
//       currentPage.value--;
//       Helpers.showErrorSnackbar(e.toString());
//     } finally {
//       isLoadingMore.value = false;
//     }
//   }
//
//   Future<void> refreshNotifications() async {
//     try {
//       isRefreshing.value = true;
//       currentPage.value = 1;
//       await loadNotifications();
//       await loadStatistics();
//     } finally {
//       isRefreshing.value = false;
//     }
//   }
//
//   Future<void> loadStatistics() async {
//     try {
//       statistics.value = await _repository.getStatistics();
//     } catch (e) {
//       print('Error loading statistics: $e');
//     }
//   }
//
//   Future<void> deleteNotification(String id) async {
//     final confirm = await Helpers.showConfirmDialog(
//       title: 'حذف الإشعار',
//       message: 'هل أنت متأكد من حذف هذا الإشعار؟',
//       confirmText: 'حذف',
//     );
//
//     if (confirm != true) return;
//
//     try {
//       await _repository.deleteNotification(id);
//       notifications.removeWhere((n) => n.id == id);
//       Helpers.showSuccessSnackbar('تم حذف الإشعار');
//     } catch (e) {
//       Helpers.showErrorSnackbar(e.toString());
//     }
//   }
//
//   void setTypeFilter(String? type) {
//     typeFilter.value = type;
//     currentPage.value = 1;
//     loadNotifications();
//   }
//
//   void setSearchQuery(String query) {
//     searchQuery.value = query;
//   }
//
//   void clearFilters() {
//     searchQuery.value = '';
//     searchController.clear();
//     typeFilter.value = null;
//     currentPage.value = 1;
//     loadNotifications();
//   }
// }