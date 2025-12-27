import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/auth_model.dart';
import '../providers/user_provider.dart';

class UserRepository {
  final UserProvider _provider = UserProvider();

  Future<UsersResponse> getUsers({
    String? search,
    String? userType,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getUsers(
        search: search,
        userType: userType,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return UsersResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _provider.getUserById(id);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> getUserByRationalId(String rationalId) async {
    try {
      final response = await _provider.getUserByRationalId(rationalId);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _provider.getCurrentUser();
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> createUser(Map<String, dynamic> data) async {
    try {
      final response = await _provider.createUser(data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await _provider.updateUser(id, data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateCurrentUser(Map<String, dynamic> data) async {
    try {
      final response = await _provider.updateCurrentUser(data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> toggleUserActive(String id) async {
    try {
      final response = await _provider.toggleUserActive(id);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteUser(String id) async {
    try {
      final response = await _provider.deleteUser(id);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> hardDeleteUser(String id) async {
    try {
      final response = await _provider.hardDeleteUser(id);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> uploadProfileImage(String filePath) async {
    try {
      final response = await _provider.uploadProfileImage(filePath);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> uploadUserImage(String userId, String filePath) async {
    try {
      final response = await _provider.uploadUserImage(userId, filePath);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> deleteProfileImage() async {
    try {
      final response = await _provider.deleteProfileImage();
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await _provider.changePassword(request);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserStatistics> getStatistics() async {
    try {
      final response = await _provider.getStatistics();
      return UserStatistics.fromJson(response.data);
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