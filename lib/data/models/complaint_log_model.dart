import 'user_model.dart';

class ComplaintLogModel {
  final String? id;
  final dynamic complaintId;
  final dynamic actionBy;
  final String actionType;
  final String description;
  final DateTime? createdAt;

  ComplaintLogModel({
    this.id,
    this.complaintId,
    this.actionBy,
    required this.actionType,
    required this.description,
    this.createdAt,
  });

  factory ComplaintLogModel.fromJson(Map<String, dynamic> json) {
    return ComplaintLogModel(
      id: json['_id'] ?? json['id'],
      complaintId: _parseComplaintPopulated(json['complaintId']),
      actionBy: _parseUserPopulated(json['actionBy']),
      actionType: json['actionType'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  static dynamic _parseUserPopulated(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return LogUser.fromJson(value);
    }
    return null;
  }

  static dynamic _parseComplaintPopulated(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return LogComplaint.fromJson(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'complaintId': complaintId,
      'actionBy': actionBy,
      'actionType': actionType,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  String? get actionByName {
    if (actionBy is LogUser) {
      return (actionBy as LogUser).fullName;
    }
    return null;
  }

  String? get complaintNumber {
    if (complaintId is LogComplaint) {
      return (complaintId as LogComplaint).complaintId;
    }
    return null;
  }
}

class LogUser {
  final String? id;
  final String fullName;
  final String? rationalId;
  final String userType;
  final String? profileImage;

  LogUser({
    this.id,
    required this.fullName,
    this.rationalId,
    required this.userType,
    this.profileImage,
  });

  factory LogUser.fromJson(Map<String, dynamic> json) {
    return LogUser(
      id: json['_id'] ?? json['id'],
      fullName: json['fullName'] ?? '',
      rationalId: json['rationalId'],
      userType: json['userType'] ?? 'citizen',
      profileImage: json['profileImage'],
    );
  }
}

class LogComplaint {
  final String? id;
  final String complaintId;
  final String? message;
  final String? type;

  LogComplaint({
    this.id,
    required this.complaintId,
    this.message,
    this.type,
  });

  factory LogComplaint.fromJson(Map<String, dynamic> json) {
    return LogComplaint(
      id: json['_id'] ?? json['id'],
      complaintId: json['complaintId'] ?? '',
      message: json['message'],
      type: json['type'],
    );
  }
}

class ComplaintLogsResponse {
  final List<ComplaintLogModel> logs;
  final PaginationModel pagination;

  ComplaintLogsResponse({
    required this.logs,
    required this.pagination,
  });

  factory ComplaintLogsResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintLogsResponse(
      logs: (json['logs'] as List<dynamic>?)
          ?.map((e) => ComplaintLogModel.fromJson(e))
          .toList() ?? [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class LogStatistics {
  final int totalLogs;
  final Map<String, int> logsByActionType;
  final List<TopUser> topUsers;

  LogStatistics({
    required this.totalLogs,
    required this.logsByActionType,
    required this.topUsers,
  });

  factory LogStatistics.fromJson(Map<String, dynamic> json) {
    return LogStatistics(
      totalLogs: json['totalLogs'] ?? 0,
      logsByActionType: Map<String, int>.from(json['logsByActionType'] ?? {}),
      topUsers: (json['topUsers'] as List<dynamic>?)
          ?.map((e) => TopUser.fromJson(e))
          .toList() ?? [],
    );
  }
}

class TopUser {
  final String id;
  final String fullName;
  final int count;

  TopUser({
    required this.id,
    required this.fullName,
    required this.count,
  });

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class CreateLogRequest {
  final String complaintId;
  final String actionType;
  final String description;

  CreateLogRequest({
    required this.complaintId,
    required this.actionType,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'complaintId': complaintId,
      'actionType': actionType,
      'description': description,
    };
  }
}