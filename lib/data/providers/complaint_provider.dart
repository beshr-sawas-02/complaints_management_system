import 'package:dio/dio.dart';
import '../../utils/constants.dart';
import '../models/complaint_model.dart';
import 'api_client.dart';

class ComplaintProvider {
  final ApiClient _apiClient = ApiClient();

  // Get all complaints with pagination and filters
  Future<Response> getComplaints({
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
    return await _apiClient.get(
      ApiEndpoints.complaints,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (userId != null) 'userId': userId,
        if (categoryId != null) 'categoryId': categoryId,
        if (status != null) 'status': status,
        if (priority != null) 'priority': priority,
        if (isRead != null) 'isRead': isRead,
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Get complaint by ID
  Future<Response> getComplaintById(String id) async {
    return await _apiClient.get(ApiEndpoints.complaintById(id));
  }

  // Get my complaints
  Future<Response> getMyComplaints({
    String? status,
    String? priority,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    return await _apiClient.get(
      ApiEndpoints.myComplaints,
      queryParameters: {
        if (status != null) 'status': status,
        if (priority != null) 'priority': priority,
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Create complaint
  Future<Response> createComplaint(CreateComplaintRequest request) async {
    return await _apiClient.post(
      ApiEndpoints.complaints,
      data: request.toJson(),
    );
  }

  // Update complaint
  Future<Response> updateComplaint(String id, UpdateComplaintRequest request) async {
    return await _apiClient.patch(
      ApiEndpoints.complaintById(id),
      data: request.toJson(),
    );
  }

  // Update complaint status
  Future<Response> updateStatus(String id, UpdateStatusRequest request) async {
    return await _apiClient.patch(
      ApiEndpoints.updateComplaintStatus(id),
      data: request.toJson(),
    );
  }

  // Assign complaint to admin
  Future<Response> assignComplaint(String id, AssignComplaintRequest request) async {
    return await _apiClient.patch(
      ApiEndpoints.assignComplaint(id),
      data: request.toJson(),
    );
  }

  // Upload images
  Future<Response> uploadImages(String id, List<String> filePaths) async {
    return await _apiClient.uploadFiles(
      ApiEndpoints.uploadComplaintImages(id),
      filePaths: filePaths,
      fieldName: 'images',
    );
  }

  // Delete image
  Future<Response> deleteImage(String id, String filename) async {
    return await _apiClient.delete(
      ApiEndpoints.deleteComplaintImage(id, filename),
    );
  }

  // Mark as read
  Future<Response> markAsRead(String id) async {
    return await _apiClient.patch(ApiEndpoints.markComplaintAsRead(id));
  }

  // Delete complaint
  Future<Response> deleteComplaint(String id) async {
    return await _apiClient.delete(ApiEndpoints.complaintById(id));
  }

  // Get statistics
  Future<Response> getStatistics() async {
    return await _apiClient.get(ApiEndpoints.complaintsStatistics);
  }
}