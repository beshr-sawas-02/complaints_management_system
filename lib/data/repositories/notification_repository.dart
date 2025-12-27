// import 'package:dio/dio.dart';
// import '../models/notification_model.dart';
// import '../providers/notification_provider.dart';
//
// class NotificationRepository {
//   final NotificationProvider _provider = NotificationProvider();
//
//   Future<NotificationsResponse> getNotifications({
//     String? search,
//     String? userId,
//     String? complaintId,
//     String? type,
//     String? newStatus,
//     String? assignedTo,
//     int page = 1,
//     int limit = 10,
//     String sortBy = 'createdAt',
//     String sortOrder = 'desc',
//   }) async {
//     try {
//       final response = await _provider.getNotifications(
//         search: search,
//         userId: userId,
//         complaintId: complaintId,
//         type: type,
//         newStatus: newStatus,
//         assignedTo: assignedTo,
//         page: page,
//         limit: limit,
//         sortBy: sortBy,
//         sortOrder: sortOrder,
//       );
//       return NotificationsResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<NotificationModel> getNotificationById(String id) async {
//     try {
//       final response = await _provider.getNotificationById(id);
//       return NotificationModel.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<NotificationsResponse> getMyNotifications({
//     String? type,
//     int page = 1,
//     int limit = 10,
//     String sortBy = 'createdAt',
//     String sortOrder = 'desc',
//   }) async {
//     try {
//       final response = await _provider.getMyNotifications(
//         type: type,
//         page: page,
//         limit: limit,
//         sortBy: sortBy,
//         sortOrder: sortOrder,
//       );
//       return NotificationsResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<List<NotificationModel>> getRecentNotifications({int limit = 10}) async {
//     try {
//       final response = await _provider.getRecentNotifications(limit: limit);
//       return (response.data as List)
//           .map((e) => NotificationModel.fromJson(e))
//           .toList();
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<List<NotificationModel>> getNotificationsByComplaint(
//       String complaintId,
//       ) async {
//     try {
//       final response = await _provider.getNotificationsByComplaint(complaintId);
//       return (response.data as List)
//           .map((e) => NotificationModel.fromJson(e))
//           .toList();
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<NotificationsResponse> getNotificationsByAssigned(
//       String userId, {
//         int page = 1,
//         int limit = 10,
//         String sortBy = 'createdAt',
//         String sortOrder = 'desc',
//       }) async {
//     try {
//       final response = await _provider.getNotificationsByAssigned(
//         userId,
//         page: page,
//         limit: limit,
//         sortBy: sortBy,
//         sortOrder: sortOrder,
//       );
//       return NotificationsResponse.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<NotificationModel> createNotification(
//       CreateNotificationRequest request,
//       ) async {
//     try {
//       final response = await _provider.createNotification(request);
//       return NotificationModel.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<NotificationModel> updateNotification(
//       String id,
//       Map<String, dynamic> data,
//       ) async {
//     try {
//       final response = await _provider.updateNotification(id, data);
//       return NotificationModel.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<Map<String, dynamic>> deleteNotification(String id) async {
//     try {
//       final response = await _provider.deleteNotification(id);
//       return response.data;
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<Map<String, dynamic>> deleteNotificationsByComplaint(
//       String complaintId,
//       ) async {
//     try {
//       final response = await _provider.deleteNotificationsByComplaint(complaintId);
//       return response.data;
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<NotificationStatistics> getStatistics() async {
//     try {
//       final response = await _provider.getStatistics();
//       return NotificationStatistics.fromJson(response.data);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   String _handleError(DioException e) {
//     if (e.response != null) {
//       final data = e.response?.data;
//       if (data is Map && data.containsKey('message')) {
//         return data['message'];
//       }
//     }
//
//     switch (e.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return 'انتهت مهلة الاتصال';
//       case DioExceptionType.connectionError:
//         return 'لا يوجد اتصال بالإنترنت';
//       default:
//         return 'حدث خطأ غير متوقع';
//     }
//   }
// }