import 'package:dio/dio.dart';
import '../../utils/constants.dart';
import '../models/user_model.dart';
import '../models/auth_model.dart';
import 'api_client.dart';

class UserProvider {
  final ApiClient _apiClient = ApiClient();

  // Get all users with pagination and filters
  Future<Response> getUsers({
    String? search,
    String? userType,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    return await _apiClient.get(
      ApiEndpoints.users,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (userType != null) 'userType': userType,
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Get user by ID
  Future<Response> getUserById(String id) async {
    return await _apiClient.get(ApiEndpoints.userById(id));
  }

  // Get user by rational ID
  Future<Response> getUserByRationalId(String rationalId) async {
    return await _apiClient.get(ApiEndpoints.userByRationalId(rationalId));
  }

  // Get current user
  Future<Response> getCurrentUser() async {
    return await _apiClient.get(ApiEndpoints.currentUser);
  }

  // Create user
  Future<Response> createUser(Map<String, dynamic> data) async {
    return await _apiClient.post(
      ApiEndpoints.users,
      data: data,
    );
  }

  // Update user
  Future<Response> updateUser(String id, Map<String, dynamic> data) async {
    return await _apiClient.patch(
      ApiEndpoints.userById(id),
      data: data,
    );
  }

  // Update current user
  Future<Response> updateCurrentUser(Map<String, dynamic> data) async {
    return await _apiClient.patch(
      ApiEndpoints.updateCurrentUser,
      data: data,
    );
  }

  // Toggle user active status
  Future<Response> toggleUserActive(String id) async {
    return await _apiClient.patch(ApiEndpoints.toggleUserActive(id));
  }

  // Soft delete user
  Future<Response> deleteUser(String id) async {
    return await _apiClient.delete(ApiEndpoints.userById(id));
  }

  // Hard delete user
  Future<Response> hardDeleteUser(String id) async {
    return await _apiClient.delete(ApiEndpoints.hardDeleteUser(id));
  }

  // Upload profile image for current user
  Future<Response> uploadProfileImage(String filePath) async {
    return await _apiClient.uploadFile(
      ApiEndpoints.uploadProfileImage,
      filePath: filePath,
      fieldName: 'image',
    );
  }

  // Upload profile image for specific user (admin)
  Future<Response> uploadUserImage(String userId, String filePath) async {
    return await _apiClient.uploadFile(
      ApiEndpoints.uploadUserImage(userId),
      filePath: filePath,
      fieldName: 'image',
    );
  }

  // Delete profile image
  Future<Response> deleteProfileImage() async {
    return await _apiClient.delete(ApiEndpoints.deleteProfileImage);
  }

  // Change password
  Future<Response> changePassword(ChangePasswordRequest request) async {
    return await _apiClient.patch(
      ApiEndpoints.changePassword,
      data: request.toJson(),
    );
  }

  // Get user statistics
  Future<Response> getStatistics() async {
    return await _apiClient.get(ApiEndpoints.userStatistics);
  }
}