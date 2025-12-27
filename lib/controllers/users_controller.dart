import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class UsersController extends GetxController {
  final UserRepository _repository = UserRepository();

  // Data
  final RxList<UserModel> users = <UserModel>[].obs;
  final Rx<UserModel?> selectedUser = Rx<UserModel?>(null);
  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
  final Rx<UserStatistics?> statistics = Rx<UserStatistics?>(null);

  // Filters
  final RxString searchQuery = ''.obs;
  final Rxn<String> userTypeFilter = Rxn<String>();
  final RxInt currentPage = 1.obs;

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isCreating = false.obs;

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final rationalIdController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final searchController = TextEditingController();
  final RxString selectedUserType = 'citizen'.obs;

  // Scroll Controller
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadStatistics();
    _setupScrollListener();

    debounce(searchQuery, (_) => _onSearchChanged(),
        time: Constants.debounceDuration);
  }

  @override
  void onClose() {
    rationalIdController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreUsers();
      }
    });
  }

  void _onSearchChanged() {
    currentPage.value = 1;
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;

      final response = await _repository.getUsers(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        userType: userTypeFilter.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      users.value = response.users;
      pagination.value = response.pagination;
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreUsers() async {
    if (isLoadingMore.value) return;
    if (pagination.value == null || !pagination.value!.hasNextPage) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await _repository.getUsers(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        userType: userTypeFilter.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      users.addAll(response.users);
      pagination.value = response.pagination;
    } catch (e) {
      currentPage.value--;
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshUsers() async {
    try {
      isRefreshing.value = true;
      currentPage.value = 1;
      await loadUsers();
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

  Future<void> loadUserDetails(String id) async {
    try {
      isLoading.value = true;
      selectedUser.value = await _repository.getUserById(id);
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isCreating.value = true;

      final data = {
        'rationalId': rationalIdController.text.trim(),
        'fullName': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'userType': selectedUserType.value,
      };

      final user = await _repository.createUser(data);
      users.insert(0, user);

      _clearForm();
      Get.back();
      Helpers.showSuccessSnackbar('تم إنشاء المستخدم بنجاح');
      await loadStatistics();
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateUser(String id) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isUpdating.value = true;

      final data = <String, dynamic>{
        'fullName': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'userType': selectedUserType.value,
      };

      if (passwordController.text.isNotEmpty) {
        data['newPassword'] = passwordController.text;
      }

      final user = await _repository.updateUser(id, data);

      // Update in list
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = user;
      }

      // Update selected user
      if (selectedUser.value?.id == id) {
        selectedUser.value = user;
      }

      _clearForm();
      Get.back();
      Helpers.showSuccessSnackbar('تم تحديث المستخدم بنجاح');
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> toggleUserActive(String id) async {
    try {
      isUpdating.value = true;

      final user = await _repository.toggleUserActive(id);

      // Update in list
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = user;
      }

      // Update selected user
      if (selectedUser.value?.id == id) {
        selectedUser.value = user;
      }

      Helpers.showSuccessSnackbar(
          user.isActive ? 'تم تفعيل المستخدم' : 'تم تعطيل المستخدم'
      );
      await loadStatistics();
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteUser(String id, {bool hard = false}) async {
    final confirm = await Helpers.showConfirmDialog(
      title: hard ? 'حذف نهائي' : 'تعطيل المستخدم',
      message: hard
          ? 'هل أنت متأكد من الحذف النهائي لهذا المستخدم؟ لا يمكن التراجع عن هذا الإجراء.'
          : 'هل أنت متأكد من تعطيل هذا المستخدم؟',
      confirmText: hard ? 'حذف نهائي' : 'تعطيل',
    );

    if (confirm != true) return;

    try {
      isUpdating.value = true;

      if (hard) {
        await _repository.hardDeleteUser(id);
        users.removeWhere((u) => u.id == id);
      } else {
        await _repository.deleteUser(id);
        final index = users.indexWhere((u) => u.id == id);
        if (index != -1) {
          users[index] = users[index].copyWith(isActive: false);
        }
      }

      if (selectedUser.value?.id == id) {
        selectedUser.value = null;
        Get.back();
      }

      Helpers.showSuccessSnackbar(hard ? 'تم حذف المستخدم نهائياً' : 'تم تعطيل المستخدم');
      await loadStatistics();
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  void prepareForEdit(UserModel user) {
    rationalIdController.text = user.rationalId;
    fullNameController.text = user.fullName;
    phoneController.text = user.phone;
    passwordController.clear();
    selectedUserType.value = user.userType;
  }

  void setUserTypeFilter(String? type) {
    userTypeFilter.value = type;
    currentPage.value = 1;
    loadUsers();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    userTypeFilter.value = null;
    currentPage.value = 1;
    loadUsers();
  }

  void _clearForm() {
    rationalIdController.clear();
    fullNameController.clear();
    phoneController.clear();
    passwordController.clear();
    selectedUserType.value = 'citizen';
  }

  void clearSelectedUser() {
    selectedUser.value = null;
  }
}