import 'package:dio/dio.dart';
import '../../utils/constants.dart';
import '../models/complaint_log_model.dart';
import 'api_client.dart';

class ComplaintLogProvider {
  final ApiClient _apiClient = ApiClient();

  // Get all logs with pagination and filters
  Future<Response> getLogs({
    String? search,
    String? complaintId,
    String? actionBy,
    String? actionType,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    return await _apiClient.get(
      ApiEndpoints.complaintLogs,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (complaintId != null) 'complaintId': complaintId,
        if (actionBy != null) 'actionBy': actionBy,
        if (actionType != null) 'actionType': actionType,
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Get log by ID
  Future<Response> getLogById(String id) async {
    return await _apiClient.get(ApiEndpoints.logById(id));
  }

  // Get logs by complaint
  Future<Response> getLogsByComplaint(String complaintId) async {
    return await _apiClient.get(ApiEndpoints.logsByComplaint(complaintId));
  }

  // Get activity timeline
  Future<Response> getActivityTimeline(String complaintId) async {
    return await _apiClient.get(ApiEndpoints.logsTimeline(complaintId));
  }

  // Get logs by user
  Future<Response> getLogsByUser(
      String userId, {
        int page = 1,
        int limit = 10,
        String sortBy = 'createdAt',
        String sortOrder = 'desc',
      }) async {
    return await _apiClient.get(
      ApiEndpoints.logsByUser(userId),
      queryParameters: {
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Create log
  Future<Response> createLog(CreateLogRequest request) async {
    return await _apiClient.post(
      ApiEndpoints.complaintLogs,
      data: request.toJson(),
    );
  }

  // Delete log
  Future<Response> deleteLog(String id) async {
    return await _apiClient.delete(ApiEndpoints.logById(id));
  }

  // Delete logs by complaint
  Future<Response> deleteLogsByComplaint(String complaintId) async {
    return await _apiClient.delete(
      ApiEndpoints.deleteLogsByComplaint(complaintId),
    );
  }

  // Get statistics
  Future<Response> getStatistics() async {
    return await _apiClient.get(ApiEndpoints.logsStatistics);
  }
}