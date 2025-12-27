import 'package:dio/dio.dart';
import '../../utils/constants.dart';
import '../models/category_model.dart';
import 'api_client.dart';

class CategoryProvider {
  final ApiClient _apiClient = ApiClient();

  // Get all categories with pagination
  Future<Response> getCategories({
    String? search,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    return await _apiClient.get(
      ApiEndpoints.categories,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Get all categories (simple list)
  Future<Response> getCategoriesList() async {
    return await _apiClient.get(ApiEndpoints.categoriesList);
  }

  // Get category by ID
  Future<Response> getCategoryById(String id) async {
    return await _apiClient.get(ApiEndpoints.categoryById(id));
  }

  // Get category by name
  Future<Response> getCategoryByName(String name) async {
    return await _apiClient.get(ApiEndpoints.categoryByName(name));
  }

  // Check if category exists
  Future<Response> checkCategoryExists(String name) async {
    return await _apiClient.get(ApiEndpoints.categoryExists(name));
  }

  // Create category
  Future<Response> createCategory(CreateCategoryRequest request) async {
    return await _apiClient.post(
      ApiEndpoints.categories,
      data: request.toJson(),
    );
  }

  // Bulk create categories
  Future<Response> bulkCreateCategories(List<CreateCategoryRequest> requests) async {
    return await _apiClient.post(
      ApiEndpoints.bulkCategories,
      data: requests.map((e) => e.toJson()).toList(),
    );
  }

  // Update category
  Future<Response> updateCategory(String id, UpdateCategoryRequest request) async {
    return await _apiClient.patch(
      ApiEndpoints.categoryById(id),
      data: request.toJson(),
    );
  }

  // Delete category
  Future<Response> deleteCategory(String id) async {
    return await _apiClient.delete(ApiEndpoints.categoryById(id));
  }

  // Get statistics
  Future<Response> getStatistics() async {
    return await _apiClient.get(ApiEndpoints.categoriesStatistics);
  }
}