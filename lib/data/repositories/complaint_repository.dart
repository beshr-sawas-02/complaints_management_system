import 'package:dio/dio.dart';
import '../models/complaint_model.dart';
import '../models/user_model.dart';
import '../providers/complaint_provider.dart';
import '../providers/user_provider.dart';

class ComplaintRepository {
  final ComplaintProvider _provider = ComplaintProvider();
  final UserProvider _userProvider = UserProvider();

  Future<ComplaintsResponse> getComplaints({
    String? search,
    String? userId,
    String? categoryId,
    String? status,
    String? priority,
    bool? isRead,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getComplaints(
        search: search,
        userId: userId,
        categoryId: categoryId,
        status: status,
        priority: priority,
        isRead: isRead,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return ComplaintsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> getComplaintById(String id) async {
    try {
      final response = await _provider.getComplaintById(id);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintsResponse> getMyComplaints({
    String? status,
    String? priority,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getMyComplaints(
        status: status,
        priority: priority,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return ComplaintsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> createComplaint(CreateComplaintRequest request) async {
    try {
      final response = await _provider.createComplaint(request);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> updateComplaint(String id, UpdateComplaintRequest request) async {
    try {
      final response = await _provider.updateComplaint(id, request);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> updateStatus(String id, UpdateStatusRequest request) async {
    try {
      final response = await _provider.updateStatus(id, request);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> assignComplaint(String id, AssignComplaintRequest request) async {
    try {
      final response = await _provider.assignComplaint(id, request);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ================ GET ADMINS FOR ASSIGNMENT ================
  Future<List<UserModel>> getAdmins() async {
    try {
      final response = await _userProvider.getUsers(
        userType: 'admin',
        limit: 100,
      );

      final List<dynamic> data = response.data['users'] ?? response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> uploadImages(String id, List<String> filePaths) async {
    try {
      final response = await _provider.uploadImages(id, filePaths);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> deleteImage(String id, String filename) async {
    try {
      final response = await _provider.deleteImage(id, filename);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintModel> markAsRead(String id) async {
    try {
      final response = await _provider.markAsRead(id);
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteComplaint(String id) async {
    try {
      final response = await _provider.deleteComplaint(id);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintStatistics> getStatistics() async {
    try {
      final response = await _provider.getStatistics();
      return ComplaintStatistics.fromJson(response.data);
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