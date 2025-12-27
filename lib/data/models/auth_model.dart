import 'user_model.dart';

class LoginRequest {
  final String rationalId;
  final String password;

  LoginRequest({
    required this.rationalId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'rationalId': rationalId,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String rationalId;
  final String fullName;
  final String phone;
  final String password;
  final String? userType;
  final String? profileImage;

  RegisterRequest({
    required this.rationalId,
    required this.fullName,
    required this.phone,
    required this.password,
    this.userType,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'rationalId': rationalId,
      'fullName': fullName,
      'phone': phone,
      'password': password,
      if (userType != null) 'userType': userType,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final AuthUser user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: AuthUser.fromJson(json['user'] ?? {}),
    );
  }
}

class AuthUser {
  final String id;
  final String rationalId;
  final String fullName;
  final String userType;
  final String phone;
  final String? profileImage;

  AuthUser({
    required this.id,
    required this.rationalId,
    required this.fullName,
    required this.userType,
    required this.phone,
    this.profileImage,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] ?? json['_id'] ?? '',
      rationalId: json['rationalId'] ?? '',
      fullName: json['fullName'] ?? '',
      userType: json['userType'] ?? 'citizen',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  UserModel toUserModel() {
    return UserModel(
      id: id,
      rationalId: rationalId,
      fullName: fullName,
      phone: phone,
      userType: userType,
      profileImage: profileImage,
      isActive: true,
    );
  }
}

class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}