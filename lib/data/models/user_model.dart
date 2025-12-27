class UserModel {
  final String? id;
  final String rationalId;
  final String fullName;
  final String phone;
  final String userType;
  final String? profileImage;
  final String? profileImageUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.rationalId,
    required this.fullName,
    required this.phone,
    required this.userType,
    this.profileImage,
    this.profileImageUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final profileImage = json['profileImage'];
    String? profileImageUrl = profileImage;

    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      rationalId: json['rationalId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      userType: json['userType']?.toString() ?? 'citizen',
      profileImage: profileImage?.toString(),
      profileImageUrl: profileImageUrl?.toString(),
      isActive: _parseBool(json['isActive']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return true;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'rationalId': rationalId,
      'fullName': fullName,
      'phone': phone,
      'userType': userType,
      'profileImage': profileImage,
      'profileImageUrl': profileImageUrl,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? rationalId,
    String? fullName,
    String? phone,
    String? userType,
    String? profileImage,
    String? profileImageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      rationalId: rationalId ?? this.rationalId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      profileImage: profileImage ?? this.profileImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isAdmin => userType == 'admin';
  bool get isCitizen => userType == 'citizen';
}

class UserStatistics {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final int citizensCount;
  final int adminsCount;

  UserStatistics({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.citizensCount,
    required this.adminsCount,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalUsers: _parseInt(json['totalUsers']),
      activeUsers: _parseInt(json['activeUsers']),
      inactiveUsers: _parseInt(json['inactiveUsers']),
      citizensCount: _parseInt(json['citizensCount']),
      adminsCount: _parseInt(json['adminsCount']),
    );
  }

  /// Helper method to safely parse int from dynamic value
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'inactiveUsers': inactiveUsers,
      'citizensCount': citizensCount,
      'adminsCount': adminsCount,
    };
  }
}

class UsersResponse {
  final List<UserModel> users;
  final PaginationModel pagination;

  UsersResponse({
    required this.users,
    required this.pagination,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: _parseInt(json['total']),
      page: _parseInt(json['page'], defaultValue: 1),
      limit: _parseInt(json['limit'], defaultValue: 10),
      totalPages: _parseInt(json['totalPages'], defaultValue: 1),
    );
  }

  /// Helper method to safely parse int from dynamic value
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value == 0 ? defaultValue : value;
    if (value is double) return value.toInt() == 0 ? defaultValue : value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return (parsed == null || parsed == 0) ? defaultValue : parsed;
    }
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}