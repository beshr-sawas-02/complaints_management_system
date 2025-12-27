import 'package:dio/dio.dart';
import '../../utils/constants.dart';
import '../models/auth_model.dart';
import 'api_client.dart';

class AuthProvider {
  final ApiClient _apiClient = ApiClient();

  Future<Response> login(LoginRequest request) async {
    return await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
  }

  Future<Response> register(RegisterRequest request) async {
    return await _apiClient.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
  }

  Future<Response> refreshToken(String refreshToken) async {
    return await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
  }

  Future<Response> getProfile() async {
    return await _apiClient.get(ApiEndpoints.profile);
  }
}