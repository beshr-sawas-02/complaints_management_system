import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/auth_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../utils/helpers.dart';
import '../utils/storage_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  // Form Controllers
  final rationalIdController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Observable States
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
    currentUser.value = StorageService.getUser();
  }

  @override
  void onClose() {
    rationalIdController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _loadSavedCredentials() {
    rememberMe.value = StorageService.getRememberMe();
    if (rememberMe.value) {
      final credentials = StorageService.getSavedCredentials();
      if (credentials != null) {
        rationalIdController.text = credentials['rationalId'] ?? '';
        passwordController.text = credentials['password'] ?? '';
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final request = LoginRequest(
        rationalId: rationalIdController.text.trim(),
        password: passwordController.text,
      );

      final response = await _repository.login(request);

      // Check if user is admin
      if (response.user.userType != 'admin') {
        Helpers.showErrorSnackbar('هذا التطبيق مخصص للمسؤولين فقط');
        await _repository.logout();
        return;
      }

      currentUser.value = response.user.toUserModel();

      // Save credentials if remember me is enabled
      if (rememberMe.value) {
        await StorageService.saveRememberMe(true);
        await StorageService.saveCredentials(
          rationalIdController.text.trim(),
          passwordController.text,
        );
      } else {
        await StorageService.saveRememberMe(false);
        await StorageService.clearCredentials();
      }

      _clearFormFields();
      Helpers.showSuccessSnackbar('تم تسجيل الدخول بنجاح');
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      Helpers.showErrorSnackbar('كلمة المرور غير متطابقة');
      return;
    }

    try {
      isLoading.value = true;

      final request = RegisterRequest(
        rationalId: rationalIdController.text.trim(),
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        userType: 'admin',
      );

      final response = await _repository.register(request);
      currentUser.value = response.user.toUserModel();

      _clearFormFields();
      Helpers.showSuccessSnackbar('تم إنشاء الحساب بنجاح');
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final confirm = await Helpers.showConfirmDialog(
      title: 'تسجيل الخروج',
      message: 'هل أنت متأكد من تسجيل الخروج؟',
      confirmText: 'خروج',
    );

    if (confirm == true) {
      await _repository.logout();
      currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> refreshProfile() async {
    try {
      final user = await _repository.getProfile();
      currentUser.value = user;
      await StorageService.saveUser(user);
    } catch (e) {
      print('Error refreshing profile: $e');
    }
  }

  bool isLoggedIn() {
    return _repository.isLoggedIn();
  }

  void _clearFormFields() {
    if (!rememberMe.value) {
      rationalIdController.clear();
      passwordController.clear();
    }
    fullNameController.clear();
    phoneController.clear();
    confirmPasswordController.clear();
  }

  void goToRegister() {
    _clearFormFields();
    Get.toNamed(AppRoutes.register);
  }

  void goToLogin() {
    _clearFormFields();
    Get.back();
  }
}