import 'user_model.dart';

class RatingModel {
  final String? id;
  final dynamic complaintId;
  final dynamic userId;
  final int rating;
  final String? feedback;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RatingModel({
    this.id,
    this.complaintId,
    this.userId,
    required this.rating,
    this.feedback,
    this.createdAt,
    this.updatedAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] ?? json['id'],
      complaintId: _parseComplaintPopulated(json['complaintId']),
      userId: _parseUserPopulated(json['userId']),
      rating: json['rating'] ?? 0,
      feedback: json['feedback'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  static dynamic _parseUserPopulated(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return RatingUser.fromJson(value);
    }
    return null;
  }

  static dynamic _parseComplaintPopulated(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return RatingComplaint.fromJson(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'complaintId': complaintId,
      'userId': userId,
      'rating': rating,
      'feedback': feedback,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String? get userFullName {
    if (userId is RatingUser) {
      return (userId as RatingUser).fullName;
    }
    return null;
  }

  String? get complaintNumber {
    if (complaintId is RatingComplaint) {
      return (complaintId as RatingComplaint).complaintId;
    }
    return null;
  }
}

class RatingUser {
  final String? id;
  final String fullName;
  final String? rationalId;
  final String userType;

  RatingUser({
    this.id,
    required this.fullName,
    this.rationalId,
    required this.userType,
  });

  factory RatingUser.fromJson(Map<String, dynamic> json) {
    return RatingUser(
      id: json['_id'] ?? json['id'],
      fullName: json['fullName'] ?? '',
      rationalId: json['rationalId'],
      userType: json['userType'] ?? 'citizen',
    );
  }
}

class RatingComplaint {
  final String? id;
  final String complaintId;
  final String? message;
  final String? type;

  RatingComplaint({
    this.id,
    required this.complaintId,
    this.message,
    this.type,
  });

  factory RatingComplaint.fromJson(Map<String, dynamic> json) {
    return RatingComplaint(
      id: json['_id'] ?? json['id'],
      complaintId: json['complaintId'] ?? '',
      message: json['message'],
      type: json['type'],
    );
  }
}

class RatingsResponse {
  final List<RatingModel> ratings;
  final PaginationModel pagination;

  RatingsResponse({
    required this.ratings,
    required this.pagination,
  });

  factory RatingsResponse.fromJson(Map<String, dynamic> json) {
    return RatingsResponse(
      ratings: (json['ratings'] as List<dynamic>?)
          ?.map((e) => RatingModel.fromJson(e))
          .toList() ?? [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class RatingStatistics {
  final int totalRatings;
  final double averageRating;
  final Map<String, int> ratingDistribution;
  final List<dynamic> topRatedComplaints;
  final List<dynamic> lowRatedComplaints;

  RatingStatistics({
    required this.totalRatings,
    required this.averageRating,
    required this.ratingDistribution,
    required this.topRatedComplaints,
    required this.lowRatedComplaints,
  });

  factory RatingStatistics.fromJson(Map<String, dynamic> json) {
    return RatingStatistics(
      totalRatings: json['totalRatings'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingDistribution: Map<String, int>.from(json['ratingDistribution'] ?? {}),
      topRatedComplaints: json['topRatedComplaints'] ?? [],
      lowRatedComplaints: json['lowRatedComplaints'] ?? [],
    );
  }
}

class CreateRatingRequest {
  final String complaintId;
  final int rating;
  final String? feedback;

  CreateRatingRequest({
    required this.complaintId,
    required this.rating,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'complaintId': complaintId,
      'rating': rating,
      if (feedback != null) 'feedback': feedback,
    };
  }
}

class UpdateRatingRequest {
  final int? rating;
  final String? feedback;

  UpdateRatingRequest({
    this.rating,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (rating != null) data['rating'] = rating;
    if (feedback != null) data['feedback'] = feedback;
    return data;
  }
}