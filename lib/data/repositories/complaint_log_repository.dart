import 'package:dio/dio.dart';
import '../models/complaint_log_model.dart';
import '../providers/complaint_log_provider.dart';

class ComplaintLogRepository {
  final ComplaintLogProvider _provider = ComplaintLogProvider();

  Future<ComplaintLogsResponse> getLogs({
    String? search,
    String? complaintId,
    String? actionBy,
    String? actionType,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getLogs(
        search: search,
        complaintId: complaintId,
        actionBy: actionBy,
        actionType: actionType,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return ComplaintLogsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintLogModel> getLogById(String id) async {
    try {
      final response = await _provider.getLogById(id);
      return ComplaintLogModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ComplaintLogModel>> getLogsByComplaint(String complaintId) async {
    try {
      final response = await _provider.getLogsByComplaint(complaintId);
      return (response.data as List)
          .map((e) => ComplaintLogModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ComplaintLogModel>> getActivityTimeline(String complaintId) async {
    try {
      final response = await _provider.getActivityTimeline(complaintId);
      return (response.data as List)
          .map((e) => ComplaintLogModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintLogsResponse> getLogsByUser(
      String userId, {
        int page = 1,
        int limit = 10,
        String sortBy = 'createdAt',
        String sortOrder = 'desc',
      }) async {
    try {
      final response = await _provider.getLogsByUser(
        userId,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return ComplaintLogsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ComplaintLogModel> createLog(CreateLogRequest request) async {
    try {
      final response = await _provider.createLog(request);
      return ComplaintLogModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteLog(String id) async {
    try {
      final response = await _provider.deleteLog(id);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteLogsByComplaint(String complaintId) async {
    try {
      final response = await _provider.deleteLogsByComplaint(complaintId);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<LogStatistics> getStatistics() async {
    try {
      final response = await _provider.getStatistics();
      return LogStatistics.fromJson(response.data);
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