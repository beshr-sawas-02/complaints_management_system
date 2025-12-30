import 'user_model.dart';
import 'category_model.dart';

class ComplaintModel {
  final String? id;
  final String complaintId;
  final dynamic userId;
  final dynamic categoryId;
  final String title;
  final String description;
  final String? location; // الإحداثيات الأصلية
  final String? locationName; // اسم الموقع (الشارع/المنطقة)
  final String status;
  final String priority;
  final List<ComplaintImage> images;
  final dynamic assignedTo;
  final DateTime? resolvedAt;
  final DateTime? closedAt;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ComplaintModel({
    this.id,
    required this.complaintId,
    this.userId,
    this.categoryId,
    required this.title,
    required this.description,
    this.location,
    this.locationName,
    required this.status,
    required this.priority,
    this.images = const [],
    this.assignedTo,
    this.resolvedAt,
    this.closedAt,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    // Parse images
    List<ComplaintImage> imagesList = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        imagesList = (json['images'] as List).map((img) {
          if (img is String) {
            return ComplaintImage(fileName: img, fileUrl: img);
          } else if (img is Map<String, dynamic>) {
            return ComplaintImage.fromJson(img);
          }
          return ComplaintImage(fileName: '', fileUrl: '');
        }).toList();
      }
    }

    return ComplaintModel(
      id: json['_id'] ?? json['id'],
      complaintId: json['complaintId'] ?? '',
      userId: _parseUserOrId(json['userId']),
      categoryId: _parseCategoryOrId(json['categoryId']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'],
      locationName: json['locationName'],
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      images: imagesList,
      assignedTo: _parseUserOrId(json['assignedTo']),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'])
          : null,
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  static dynamic _parseUserOrId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return UserModel.fromJson(value);
    }
    return null;
  }

  static dynamic _parseCategoryOrId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return CategoryModel.fromJson(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'complaintId': complaintId,
      'userId': userId is UserModel ? (userId as UserModel).id : userId,
      'categoryId': categoryId is CategoryModel
          ? (categoryId as CategoryModel).id
          : categoryId,
      'title': title,
      'description': description,
      'location': location,
      'locationName': locationName,
      'status': status,
      'priority': priority,
      'images': images.map((e) => e.toJson()).toList(),
      'assignedTo': assignedTo is UserModel
          ? (assignedTo as UserModel).id
          : assignedTo,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  String? get userFullName {
    if (userId is UserModel) {
      return (userId as UserModel).fullName;
    }
    return null;
  }

  String? get categoryName {
    if (categoryId is CategoryModel) {
      return (categoryId as CategoryModel).complaintItem;
    }
    return null;
  }

  String? get assignedToName {
    if (assignedTo is UserModel) {
      return (assignedTo as UserModel).fullName;
    }
    return null;
  }

  /// يرجع اسم الموقع إذا كان متاحاً، وإلا يرجع الإحداثيات
  String? get displayLocation => locationName ?? location;

  /// يتحقق إذا كان الموقع عبارة عن إحداثيات
  bool get hasCoordinates {
    if (location == null) return false;
    final coordsRegex = RegExp(r'(-?\d+\.?\d+)\s*,\s*(-?\d+\.?\d+)');
    return coordsRegex.hasMatch(location!);
  }

  /// يستخرج الإحداثيات من الموقع
  ({double lat, double lng})? get coordinates {
    if (location == null) return null;
    final coordsRegex = RegExp(r'(-?\d+\.?\d+)\s*,\s*(-?\d+\.?\d+)');
    final match = coordsRegex.firstMatch(location!);
    if (match != null) {
      return (
      lat: double.tryParse(match.group(1)!) ?? 0,
      lng: double.tryParse(match.group(2)!) ?? 0,
      );
    }
    return null;
  }

  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isResolved => status == 'resolved';
  bool get isClosed => status == 'closed';

  ComplaintModel copyWith({
    String? id,
    String? complaintId,
    dynamic userId,
    dynamic categoryId,
    String? title,
    String? description,
    String? location,
    String? locationName,
    String? status,
    String? priority,
    List<ComplaintImage>? images,
    dynamic assignedTo,
    DateTime? resolvedAt,
    DateTime? closedAt,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      complaintId: complaintId ?? this.complaintId,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      locationName: locationName ?? this.locationName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      images: images ?? this.images,
      assignedTo: assignedTo ?? this.assignedTo,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      closedAt: closedAt ?? this.closedAt,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ComplaintImage {
  final String fileName;
  final String fileUrl;

  ComplaintImage({
    required this.fileName,
    required this.fileUrl,
  });

  factory ComplaintImage.fromJson(Map<String, dynamic> json) {
    return ComplaintImage(
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
    };
  }
}

class ComplaintsResponse {
  final List<ComplaintModel> complaints;
  final PaginationModel pagination;

  ComplaintsResponse({
    required this.complaints,
    required this.pagination,
  });

  factory ComplaintsResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintsResponse(
      complaints: (json['complaints'] as List<dynamic>?)
          ?.map((e) => ComplaintModel.fromJson(e))
          .toList() ?? [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class ComplaintStatistics {
  final int totalComplaints;
  final int unreadCount;
  final Map<String, int> byStatus;
  final Map<String, int> byPriority;

  ComplaintStatistics({
    required this.totalComplaints,
    required this.unreadCount,
    required this.byStatus,
    required this.byPriority,
  });

  factory ComplaintStatistics.fromJson(Map<String, dynamic> json) {
    return ComplaintStatistics(
      totalComplaints: json['totalComplaints'] ?? 0,
      unreadCount: json['unreadCount'] ?? 0,
      byStatus: Map<String, int>.from(json['byStatus'] ?? {}),
      byPriority: Map<String, int>.from(json['byPriority'] ?? {}),
    );
  }

  int get pendingCount => byStatus['pending'] ?? 0;
  int get inProgressCount => byStatus['in_progress'] ?? 0;
  int get resolvedCount => byStatus['resolved'] ?? 0;
  int get closedCount => byStatus['closed'] ?? 0;
}

class CreateComplaintRequest {
  final String? categoryId;
  final String title;
  final String description;
  final String? location;
  final String? locationName;
  final String? priority;

  CreateComplaintRequest({
    this.categoryId,
    required this.title,
    required this.description,
    this.location,
    this.locationName,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) 'categoryId': categoryId,
      'title': title,
      'description': description,
      if (location != null) 'location': location,
      if (locationName != null) 'locationName': locationName,
      if (priority != null) 'priority': priority,
    };
  }
}

class UpdateComplaintRequest {
  final String? categoryId;
  final String? title;
  final String? description;
  final String? location;
  final String? locationName;
  final String? priority;

  UpdateComplaintRequest({
    this.categoryId,
    this.title,
    this.description,
    this.location,
    this.locationName,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (categoryId != null) data['categoryId'] = categoryId;
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (location != null) data['location'] = location;
    if (locationName != null) data['locationName'] = locationName;
    if (priority != null) data['priority'] = priority;
    return data;
  }
}

class UpdateStatusRequest {
  final String status;
  final String? note;

  UpdateStatusRequest({
    required this.status,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (note != null) 'note': note,
    };
  }
}

class AssignComplaintRequest {
  final String adminId;

  AssignComplaintRequest({required this.adminId});

  Map<String, dynamic> toJson() {
    return {'adminId': adminId};
  }
}