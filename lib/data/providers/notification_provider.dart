// import 'package:dio/dio.dart';
// import '../../utils/constants.dart';
// import '../models/notification_model.dart';
// import 'api_client.dart';
//
// class NotificationProvider {
//   final ApiClient _apiClient = ApiClient();
//
//   // Get all notifications with pagination and filters
//   Future<Response> getNotifications({
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
//     return await _apiClient.get(
//       ApiEndpoints.notifications,
//       queryParameters: {
//         if (search != null && search.isNotEmpty) 'search': search,
//         if (userId != null) 'userId': userId,
//         if (complaintId != null) 'complaintId': complaintId,
//         if (type != null) 'type': type,
//         if (newStatus != null) 'newStatus': newStatus,
//         if (assignedTo != null) 'assignedTo': assignedTo,
//         'page': page,
//         'limit': limit,
//         'sortBy': sortBy,
//         'sortOrder': sortOrder,
//       },
//     );
//   }
//
//   // Get notification by ID
//   Future<Response> getNotificationById(String id) async {
//     return await _apiClient.get(ApiEndpoints.notificationById(id));
//   }
//
//   // Get my notifications
//   Future<Response> getMyNotifications({
//     String? type,
//     int page = 1,
//     int limit = 10,
//     String sortBy = 'createdAt',
//     String sortOrder = 'desc',
//   }) async {
//     return await _apiClient.get(
//       ApiEndpoints.myNotifications,
//       queryParameters: {
//         if (type != null) 'type': type,
//         'page': page,
//         'limit': limit,
//         'sortBy': sortBy,
//         'sortOrder': sortOrder,
//       },
//     );
//   }
//
//   // Get recent notifications
//   Future<Response> getRecentNotifications({int limit = 10}) async {
//     return await _apiClient.get(
//       ApiEndpoints.recentNotifications,
//       queryParameters: {'limit': limit},
//     );
//   }
//
//   // Get notifications by complaint
//   Future<Response> getNotificationsByComplaint(String complaintId) async {
//     return await _apiClient.get(
//       ApiEndpoints.notificationsByComplaint(complaintId),
//     );
//   }
//
//   // Get notifications by assigned user
//   Future<Response> getNotificationsByAssigned(
//       String userId, {
//         int page = 1,
//         int limit = 10,
//         String sortBy = 'createdAt',
//         String sortOrder = 'desc',
//       }) async {
//     return await _apiClient.get(
//       ApiEndpoints.notificationsByAssigned(userId),
//       queryParameters: {
//         'page': page,
//         'limit': limit,
//         'sortBy': sortBy,
//         'sortOrder': sortOrder,
//       },
//     );
//   }
//
//   // Create notification
//   Future<Response> createNotification(CreateNotificationRequest request) async {
//     return await _apiClient.post(
//       ApiEndpoints.notifications,
//       data: request.toJson(),
//     );
//   }
//
//   // Update notification
//   Future<Response> updateNotification(String id, Map<String, dynamic> data) async {
//     return await _apiClient.patch(
//       ApiEndpoints.notificationById(id),
//       data: data,
//     );
//   }
//
//   // Delete notification
//   Future<Response> deleteNotification(String id) async {
//     return await _apiClient.delete(ApiEndpoints.notificationById(id));
//   }
//
//   // Delete notifications by complaint
//   Future<Response> deleteNotificationsByComplaint(String complaintId) async {
//     return await _apiClient.delete(
//       ApiEndpoints.deleteNotificationsByComplaint(complaintId),
//     );
//   }
//
//   // Get statistics
//   Future<Response> getStatistics() async {
//     return await _apiClient.get(ApiEndpoints.notificationsStatistics);
//   }
// }