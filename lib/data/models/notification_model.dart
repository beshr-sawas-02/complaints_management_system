// import 'user_model.dart';
//
// class NotificationModel {
//   final String? id;
//   final dynamic userId;
//   final dynamic complaintId;
//   final String? file;
//   final String message;
//   final String type;
//   final String oldStatus;
//   final String newStatus;
//   final dynamic assignedTo;
//   final String? note;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   NotificationModel({
//     this.id,
//     this.userId,
//     this.complaintId,
//     this.file,
//     required this.message,
//     required this.type,
//     required this.oldStatus,
//     required this.newStatus,
//     this.assignedTo,
//     this.note,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       id: json['_id'] ?? json['id'],
//       userId: _parsePopulated(json['userId']),
//       complaintId: _parseComplaintPopulated(json['complaintId']),
//       file: json['file'],
//       message: json['message'] ?? '',
//       type: json['type'] ?? 'status_update',
//       oldStatus: json['oldStatus'] ?? 'pending',
//       newStatus: json['newStatus'] ?? 'pending',
//       assignedTo: _parsePopulated(json['assignedTo']),
//       note: json['note'],
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'])
//           : null,
//     );
//   }
//
//   static dynamic _parsePopulated(dynamic value) {
//     if (value == null) return null;
//     if (value is String) return value;
//     if (value is Map<String, dynamic>) {
//       return NotificationUser.fromJson(value);
//     }
//     return null;
//   }
//
//   static dynamic _parseComplaintPopulated(dynamic value) {
//     if (value == null) return null;
//     if (value is String) return value;
//     if (value is Map<String, dynamic>) {
//       return NotificationComplaint.fromJson(value);
//     }
//     return null;
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       'complaintId': complaintId,
//       'file': file,
//       'message': message,
//       'type': type,
//       'oldStatus': oldStatus,
//       'newStatus': newStatus,
//       'assignedTo': assignedTo,
//       'note': note,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
//
//   // Helper getters
//   String? get userFullName {
//     if (userId is NotificationUser) {
//       return (userId as NotificationUser).fullName;
//     }
//     return null;
//   }
//
//   String? get complaintNumber {
//     if (complaintId is NotificationComplaint) {
//       return (complaintId as NotificationComplaint).complaintId;
//     }
//     return null;
//   }
//
//   String? get complaintMessage {
//     if (complaintId is NotificationComplaint) {
//       return (complaintId as NotificationComplaint).message;
//     }
//     return null;
//   }
// }
//
// class NotificationUser {
//   final String? id;
//   final String fullName;
//   final String? rationalId;
//   final String? phone;
//   final String userType;
//
//   NotificationUser({
//     this.id,
//     required this.fullName,
//     this.rationalId,
//     this.phone,
//     required this.userType,
//   });
//
//   factory NotificationUser.fromJson(Map<String, dynamic> json) {
//     return NotificationUser(
//       id: json['_id'] ?? json['id'],
//       fullName: json['fullName'] ?? '',
//       rationalId: json['rationalId'],
//       phone: json['phone'],
//       userType: json['userType'] ?? 'citizen',
//     );
//   }
// }
//
// class NotificationComplaint {
//   final String? id;
//   final String complaintId;
//   final String? message;
//   final String? type;
//
//   NotificationComplaint({
//     this.id,
//     required this.complaintId,
//     this.message,
//     this.type,
//   });
//
//   factory NotificationComplaint.fromJson(Map<String, dynamic> json) {
//     return NotificationComplaint(
//       id: json['_id'] ?? json['id'],
//       complaintId: json['complaintId'] ?? '',
//       message: json['message'],
//       type: json['type'],
//     );
//   }
// }
//
// class NotificationsResponse {
//   final List<NotificationModel> notifications;
//   final PaginationModel pagination;
//
//   NotificationsResponse({
//     required this.notifications,
//     required this.pagination,
//   });
//
//   factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
//     return NotificationsResponse(
//       notifications: (json['notifications'] as List<dynamic>?)
//           ?.map((e) => NotificationModel.fromJson(e))
//           .toList() ?? [],
//       pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
//     );
//   }
// }
//
// class NotificationStatistics {
//   final int totalNotifications;
//   final Map<String, int> byType;
//   final Map<String, int> byStatus;
//
//   NotificationStatistics({
//     required this.totalNotifications,
//     required this.byType,
//     required this.byStatus,
//   });
//
//   factory NotificationStatistics.fromJson(Map<String, dynamic> json) {
//     return NotificationStatistics(
//       totalNotifications: json['totalNotifications'] ?? 0,
//       byType: Map<String, int>.from(json['byType'] ?? {}),
//       byStatus: Map<String, int>.from(json['byStatus'] ?? {}),
//     );
//   }
// }
//
// class CreateNotificationRequest {
//   final String userId;
//   final String complaintId;
//   final String message;
//   final String type;
//   final String? oldStatus;
//   final String? newStatus;
//   final String? assignedTo;
//   final String? note;
//   final String? file;
//
//   CreateNotificationRequest({
//     required this.userId,
//     required this.complaintId,
//     required this.message,
//     required this.type,
//     this.oldStatus,
//     this.newStatus,
//     this.assignedTo,
//     this.note,
//     this.file,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'complaintId': complaintId,
//       'message': message,
//       'type': type,
//       if (oldStatus != null) 'oldStatus': oldStatus,
//       if (newStatus != null) 'newStatus': newStatus,
//       if (assignedTo != null) 'assignedTo': assignedTo,
//       if (note != null) 'note': note,
//       if (file != null) 'file': file,
//     };
//   }
// }