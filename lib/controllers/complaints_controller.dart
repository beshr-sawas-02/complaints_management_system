import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/complaint_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/complaint_repository.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class ComplaintsController extends GetxController {
  final ComplaintRepository _repository = ComplaintRepository();

  // Data
  final RxList<ComplaintModel> complaints = <ComplaintModel>[].obs;
  final Rx<ComplaintModel?> selectedComplaint = Rx<ComplaintModel?>(null);
  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);

  // Filters
  final RxString searchQuery = ''.obs;
  final Rxn<String> statusFilter = Rxn<String>();
  final Rxn<String> priorityFilter = Rxn<String>();
  final Rxn<String> categoryFilter = Rxn<String>();
  final RxBool isReadFilter = RxBool(false);
  final RxInt currentPage = 1.obs;

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isUpdating = false.obs;

  // Search Controller
  final searchController = TextEditingController();

  // Scroll Controller for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadComplaints();
    _setupScrollListener();

    // Debounce search
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
        loadMoreComplaints();
      }
    });
  }

  void _onSearchChanged() {
    currentPage.value = 1;
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    try {
      isLoading.value = true;

      final response = await _repository.getComplaints(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: statusFilter.value,
        priority: priorityFilter.value,
        categoryId: categoryFilter.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      complaints.value = response.complaints;
      pagination.value = response.pagination;
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreComplaints() async {
    if (isLoadingMore.value) return;
    if (pagination.value == null || !pagination.value!.hasNextPage) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await _repository.getComplaints(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: statusFilter.value,
        priority: priorityFilter.value,
        categoryId: categoryFilter.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      complaints.addAll(response.complaints);
      pagination.value = response.pagination;
    } catch (e) {
      currentPage.value--;
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshComplaints() async {
    try {
      isRefreshing.value = true;
      currentPage.value = 1;
      await loadComplaints();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> loadComplaintDetails(String id) async {
    try {
      isLoading.value = true;
      selectedComplaint.value = await _repository.getComplaintById(id);
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateComplaintStatus(String id, String status, {String? note}) async {
    try {
      isUpdating.value = true;

      final request = UpdateStatusRequest(status: status, note: note);
      final updated = await _repository.updateStatus(id, request);

      // Update in list
      final index = complaints.indexWhere((c) => c.id == id);
      if (index != -1) {
        complaints[index] = updated;
      }

      // Update selected complaint
      if (selectedComplaint.value?.id == id) {
        selectedComplaint.value = updated;
      }

      Helpers.showSuccessSnackbar('تم تحديث حالة الشكوى');
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  // ================ GET ADMINS FOR ASSIGNMENT ================
  Future<List<UserModel>> getAdminsForAssignment() async {
    try {
      final admins = await _repository.getAdmins();
      // فلترة المسؤولين النشطين فقط
      return admins.where((user) =>
      user.userType == 'admin' && user.isActive
      ).toList();
    } catch (e) {
      throw Exception('فشل في جلب المسؤولين: $e');
    }
  }

  // ================ ASSIGN COMPLAINT ================
  Future<void> assignComplaint(String id, String adminId) async {
    try {
      isUpdating.value = true;

      final request = AssignComplaintRequest(adminId: adminId);
      final updated = await _repository.assignComplaint(id, request);

      // Update in list
      final index = complaints.indexWhere((c) => c.id == id);
      if (index != -1) {
        complaints[index] = updated;
      }

      // Update selected complaint
      if (selectedComplaint.value?.id == id) {
        selectedComplaint.value = updated;
      }

    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
      rethrow;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final updated = await _repository.markAsRead(id);

      // Update in list
      final index = complaints.indexWhere((c) => c.id == id);
      if (index != -1) {
        complaints[index] = updated;
      }

      // Update selected complaint
      if (selectedComplaint.value?.id == id) {
        selectedComplaint.value = updated;
      }
    } catch (e) {
      print('Error marking as read: $e');
    }
  }

  Future<void> deleteComplaint(String id) async {
    final confirm = await Helpers.showConfirmDialog(
      title: 'حذف الشكوى',
      message: 'هل أنت متأكد من حذف هذه الشكوى؟',
      confirmText: 'حذف',
    );

    if (confirm != true) return;

    try {
      isUpdating.value = true;
      await _repository.deleteComplaint(id);

      complaints.removeWhere((c) => c.id == id);

      if (selectedComplaint.value?.id == id) {
        selectedComplaint.value = null;
        Get.back();
      }

      Helpers.showSuccessSnackbar('تم حذف الشكوى');
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  void setStatusFilter(String? status) {
    statusFilter.value = status;
    currentPage.value = 1;
    loadComplaints();
  }

  void setPriorityFilter(String? priority) {
    priorityFilter.value = priority;
    currentPage.value = 1;
    loadComplaints();
  }

  void setCategoryFilter(String? categoryId) {
    categoryFilter.value = categoryId;
    currentPage.value = 1;
    loadComplaints();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    statusFilter.value = null;
    priorityFilter.value = null;
    categoryFilter.value = null;
    currentPage.value = 1;
    loadComplaints();
  }

  void clearSelectedComplaint() {
    selectedComplaint.value = null;
  }
}