import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../providers/category_provider.dart';

class CategoryRepository {
  final CategoryProvider _provider = CategoryProvider();

  Future<CategoriesResponse> getCategories({
    String? search,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getCategories(
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return CategoriesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<CategoryModel>> getCategoriesList() async {
    try {
      final response = await _provider.getCategoriesList();
      return (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final response = await _provider.getCategoryById(id);
      return CategoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CategoryModel> getCategoryByName(String name) async {
    try {
      final response = await _provider.getCategoryByName(name);
      return CategoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> checkCategoryExists(String name) async {
    try {
      final response = await _provider.checkCategoryExists(name);
      return response.data['exists'] ?? false;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CategoryModel> createCategory(CreateCategoryRequest request) async {
    try {
      final response = await _provider.createCategory(request);
      return CategoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> bulkCreateCategories(
      List<CreateCategoryRequest> requests,
      ) async {
    try {
      final response = await _provider.bulkCreateCategories(requests);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CategoryModel> updateCategory(
      String id,
      UpdateCategoryRequest request,
      ) async {
    try {
      final response = await _provider.updateCategory(id, request);
      return CategoryModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteCategory(String id) async {
    try {
      final response = await _provider.deleteCategory(id);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CategoryStatistics> getStatistics() async {
    try {
      final response = await _provider.getStatistics();
      return CategoryStatistics.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}