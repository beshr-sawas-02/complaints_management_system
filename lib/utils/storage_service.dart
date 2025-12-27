import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'constants.dart';
import '../data/models/user_model.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  // ================ Token Management ================
  static Future<void> saveToken(String token) async {
    await _box.write(Constants.tokenKey, token);
  }

  static String? getToken() {
    return _box.read<String>(Constants.tokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _box.write(Constants.refreshTokenKey, token);
  }

  static String? getRefreshToken() {
    return _box.read<String>(Constants.refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    await _box.remove(Constants.tokenKey);
    await _box.remove(Constants.refreshTokenKey);
  }

  static bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // ================ User Data Management ================
  static Future<void> saveUser(UserModel user) async {
    await _box.write(Constants.userKey, jsonEncode(user.toJson()));
  }

  static UserModel? getUser() {
    final userData = _box.read<String>(Constants.userKey);
    if (userData == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(userData));
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await _box.remove(Constants.userKey);
  }

  static bool isAdmin() {
    final user = getUser();
    return user?.userType == 'admin';
  }

  // ================ Theme Management ================
  static Future<void> saveThemeMode(bool isDark) async {
    await _box.write(Constants.themeKey, isDark);
  }

  static bool isDarkMode() {
    return _box.read<bool>(Constants.themeKey) ?? false;
  }

  // ================ Language Management ================
  static Future<void> saveLanguage(String languageCode) async {
    await _box.write(Constants.languageKey, languageCode);
  }

  static String getLanguage() {
    return _box.read<String>(Constants.languageKey) ?? 'ar';
  }

  // ================ First Time Check ================
  static Future<void> setFirstTime(bool value) async {
    await _box.write(Constants.isFirstTimeKey, value);
  }

  static bool isFirstTime() {
    return _box.read<bool>(Constants.isFirstTimeKey) ?? true;
  }

  // ================ Remember Me ================
  static Future<void> saveRememberMe(bool value) async {
    await _box.write(Constants.rememberMeKey, value);
  }

  static bool getRememberMe() {
    return _box.read<bool>(Constants.rememberMeKey) ?? false;
  }

  // ================ Login Credentials (if remember me) ================
  static Future<void> saveCredentials(String rationalId, String password) async {
    await _box.write('saved_rational_id', rationalId);
    await _box.write('saved_password', password);
  }

  static Map<String, String>? getSavedCredentials() {
    final rationalId = _box.read<String>('saved_rational_id');
    final password = _box.read<String>('saved_password');
    if (rationalId != null && password != null) {
      return {'rationalId': rationalId, 'password': password};
    }
    return null;
  }

  static Future<void> clearCredentials() async {
    await _box.remove('saved_rational_id');
    await _box.remove('saved_password');
  }

  // ================ Clear All Data ================
  static Future<void> clearAll() async {
    await _box.erase();
  }

  // ================ Logout ================
  static Future<void> logout() async {
    await clearTokens();
    await clearUser();
    // Keep remember me preference and saved credentials if enabled
  }
}