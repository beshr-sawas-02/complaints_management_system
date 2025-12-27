import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/category_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/category_repository.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class CategoriesController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();

  // Data
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
  final Rx<CategoryStatistics?> statistics = Rx<CategoryStatistics?>(null);

  // Filters
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isCreating = false.obs;

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final complaintItemController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  // Scroll Controller
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadCategoriesList();
    loadStatistics();
    _setupScrollListener();

    debounce(searchQuery, (_) => _onSearchChanged(),
        time: Constants.debounceDuration);
  }

  @override
  void onClose() {
    complaintItemController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreCategories();
      }
    });
  }

  void _onSearchChanged() {
    currentPage.value = 1;
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;

      final response = await _repository.getCategories(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      categories.value = response.categories;
      pagination.value = response.pagination;
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreCategories() async {
    if (isLoadingMore.value) return;
    if (pagination.value == null || !pagination.value!.hasNextPage) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await _repository.getCategories(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        page: currentPage.value,
        limit: Constants.defaultPageSize,
      );

      categories.addAll(response.categories);
      pagination.value = response.pagination;
    } catch (e) {
      currentPage.value--;
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadCategoriesList() async {
    try {
      categoriesList.value = await _repository.getCategoriesList();
    } catch (e) {
      print('Error loading categories list: $e');
    }
  }

  Future<void> refreshCategories() async {
    try {
      isRefreshing.value = true;
      currentPage.value = 1;
      await loadCategories();
      await loadCategoriesList();
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

  Future<void> createCategory() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isCreating.value = true;

      final request = CreateCategoryRequest(
        complaintItem: complaintItemController.text.trim(),
        description: descriptionController.text.trim(),
      );

      final category = await _repository.createCategory(request);
      categories.insert(0, category);
      categoriesList.add(category);

      _clearForm();
      Get.back();
      Helpers.showSuccessSnackbar('تم إنشاء التصنيف بنجاح');
      await loadStatistics();
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> updateCategory(String id) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isUpdating.value = true;

      final request = UpdateCategoryRequest(
        complaintItem: complaintItemController.text.trim(),
        description: descriptionController.text.trim(),
      );

      final category = await _repository.updateCategory(id, request);

      // Update in list
      final index = categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        categories[index] = category;
      }

      // Update in dropdown list
      final listIndex = categoriesList.indexWhere((c) => c.id == id);
      if (listIndex != -1) {
        categoriesList[listIndex] = category;
      }

      // Update selected category
      if (selectedCategory.value?.id == id) {
        selectedCategory.value = category;
      }

      _clearForm();
      Get.back();
      Helpers.showSuccessSnackbar('تم تحديث التصنيف بنجاح');
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteCategory(String id) async {
    final confirm = await Helpers.showConfirmDialog(
      title: 'حذف التصنيف',
      message: 'هل أنت متأكد من حذف هذا التصنيف؟',
      confirmText: 'حذف',
    );

    if (confirm != true) return;

    try {
      isUpdating.value = true;
      await _repository.deleteCategory(id);

      categories.removeWhere((c) => c.id == id);
      categoriesList.removeWhere((c) => c.id == id);

      if (selectedCategory.value?.id == id) {
        selectedCategory.value = null;
        Get.back();
      }

      Helpers.showSuccessSnackbar('تم حذف التصنيف بنجاح');
      await loadStatistics();
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  void prepareForEdit(CategoryModel category) {
    complaintItemController.text = category.complaintItem;
    descriptionController.text = category.description;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    currentPage.value = 1;
    loadCategories();
  }

  void _clearForm() {
    complaintItemController.clear();
    descriptionController.clear();
  }

  void clearSelectedCategory() {
    selectedCategory.value = null;
  }
}