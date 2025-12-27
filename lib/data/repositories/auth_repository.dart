import 'package:dio/dio.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../../utils/storage_service.dart';

class AuthRepository {
  final AuthProvider _provider = AuthProvider();

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _provider.login(request);
      final authResponse = AuthResponse.fromJson(response.data);

      // Save tokens
      await StorageService.saveToken(authResponse.accessToken);
      await StorageService.saveRefreshToken(authResponse.refreshToken);

      // Save user
      await StorageService.saveUser(authResponse.user.toUserModel());

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _provider.register(request);
      final authResponse = AuthResponse.fromJson(response.data);

      // Save tokens
      await StorageService.saveToken(authResponse.accessToken);
      await StorageService.saveRefreshToken(authResponse.refreshToken);

      // Save user
      await StorageService.saveUser(authResponse.user.toUserModel());

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _provider.getProfile();
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await StorageService.logout();
  }

  bool isLoggedIn() {
    return StorageService.hasToken();
  }

  UserModel? getCurrentUser() {
    return StorageService.getUser();
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
        return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}