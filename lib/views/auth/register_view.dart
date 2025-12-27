import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/helpers.dart';

/// iOS 26 Inspired Register View
class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: Stack(
        children: [
          // Background Gradient
          _BackgroundGradient(),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _iOS26Header(),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: controller.registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Title Section
                          _TitleSection(),
                          const SizedBox(height: 32),

                          // Form Card
                          _RegisterFormCard(controller: controller),
                          const SizedBox(height: 24),

                          // Register Button
                          _RegisterButton(controller: controller),
                          const SizedBox(height: 24),

                          // Login Link
                          _LoginLink(controller: controller),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// iOS 26 Color System
class iOS26Colors {
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color surfaceElevated = Color(0xFF1C1C1E);
  static const Color surfaceGlass = Color(0xFF2C2C2E);
  static const Color surfaceCard = Color(0xFF1A1A1C);

  static const Color accentBlue = Color(0xFF0A84FF);
  static const Color accentIndigo = Color(0xFF5E5CE6);
  static const Color accentPurple = Color(0xFFBF5AF2);
  static const Color accentTeal = Color(0xFF64D2FF);
  static const Color accentGreen = Color(0xFF30D158);
  static const Color accentOrange = Color(0xFFFF9F0A);
  static const Color accentRed = Color(0xFFFF453A);

  static const Color textPrimary = Color(0xFFE5E5E7);
  static const Color textSecondary = Color(0xFF98989F);
  static const Color textTertiary = Color(0xFF636366);

  static const Color borderPrimary = Color(0xFF38383A);
}

/// Background Gradient
class _BackgroundGradient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.5, -0.3),
            radius: 1.5,
            colors: [
              iOS26Colors.accentBlue.withOpacity(0.12),
              iOS26Colors.backgroundPrimary,
            ],
          ),
        ),
      ),
    );
  }
}

/// iOS 26 Header
class _iOS26Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Get.back();
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iOS26Colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: iOS26Colors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Title Section
class _TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iOS26Colors.accentBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Iconsax.user_add5,
                color: iOS26Colors.accentBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: iOS26Colors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'أدخل بياناتك لإنشاء حساب',
                    style: TextStyle(
                      fontSize: 14,
                      color: iOS26Colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Register Form Card
class _RegisterFormCard extends StatelessWidget {
  final AuthController controller;

  const _RegisterFormCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Full Name
          _iOS26TextField(
            controller: controller.fullNameController,
            label: 'الاسم الكامل',
            hint: 'أدخل الاسم الكامل',
            icon: Iconsax.user,
            validator: (value) => Helpers.validateRequired(value, 'الاسم'),
          ),
          const SizedBox(height: 20),

          // Rational ID
          _iOS26TextField(
            controller: controller.rationalIdController,
            label: 'الرقم الوطني',
            hint: 'أدخل الرقم الوطني',
            icon: Iconsax.personalcard,
            keyboardType: TextInputType.number,
            validator: (value) => Helpers.validateRationalId(value),
          ),
          const SizedBox(height: 20),

          // Phone
          _iOS26TextField(
            controller: controller.phoneController,
            label: 'رقم الهاتف',
            hint: 'أدخل رقم الهاتف',
            icon: Iconsax.call,
            keyboardType: TextInputType.phone,
            validator: (value) => Helpers.validatePhone(value),
          ),
          const SizedBox(height: 20),

          // Password
          _iOS26PasswordField(
            controller: controller.passwordController,
            label: 'كلمة المرور',
            hint: 'أدخل كلمة المرور',
            isVisible: controller.isPasswordVisible,
            onToggle: controller.togglePasswordVisibility,
            validator: (value) => Helpers.validatePassword(value),
          ),
          const SizedBox(height: 20),

          // Confirm Password
          _iOS26PasswordField(
            controller: controller.confirmPasswordController,
            label: 'تأكيد كلمة المرور',
            hint: 'أعد إدخال كلمة المرور',
            isVisible: controller.isConfirmPasswordVisible,
            onToggle: controller.toggleConfirmPasswordVisibility,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'تأكيد كلمة المرور مطلوب';
              }
              if (value != controller.passwordController.text) {
                return 'كلمة المرور غير متطابقة';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

/// iOS 26 Text Field
class _iOS26TextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _iOS26TextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_iOS26TextField> createState() => _iOS26TextFieldState();
}

class _iOS26TextFieldState extends State<_iOS26TextField> {
  bool _isFocused = false;
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: hasError
                  ? iOS26Colors.accentRed
                  : _isFocused
                  ? iOS26Colors.accentBlue
                  : iOS26Colors.textSecondary,
            ),
          ),
        ),
        // Input Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: iOS26Colors.surfaceGlass,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError
                  ? iOS26Colors.accentRed.withOpacity(0.6)
                  : _isFocused
                  ? iOS26Colors.accentBlue.withOpacity(0.6)
                  : iOS26Colors.borderPrimary.withOpacity(0.4),
              width: _isFocused || hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: hasError
                    ? iOS26Colors.accentRed
                    : _isFocused
                    ? iOS26Colors.accentBlue
                    : iOS26Colors.textTertiary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  style: const TextStyle(
                    color: iOS26Colors.textPrimary,
                    fontSize: 15,
                  ),
                  cursorColor: iOS26Colors.accentBlue,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      color: iOS26Colors.textTertiary,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    isCollapsed: true,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _errorText = error);
                    });
                    return error;
                  },
                ),
              ),
            ],
          ),
        ),
        // Error Text
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 8),
            child: Row(
              children: [
                const Icon(
                  Iconsax.warning_2,
                  color: iOS26Colors.accentRed,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _errorText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: iOS26Colors.accentRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// iOS 26 Password Field
class _iOS26PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final RxBool isVisible;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _iOS26PasswordField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isVisible,
    required this.onToggle,
    this.validator,
  });

  @override
  State<_iOS26PasswordField> createState() => _iOS26PasswordFieldState();
}

class _iOS26PasswordFieldState extends State<_iOS26PasswordField> {
  bool _isFocused = false;
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: hasError
                  ? iOS26Colors.accentRed
                  : _isFocused
                  ? iOS26Colors.accentBlue
                  : iOS26Colors.textSecondary,
            ),
          ),
        ),
        // Input Container
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: iOS26Colors.surfaceGlass,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError
                  ? iOS26Colors.accentRed.withOpacity(0.6)
                  : _isFocused
                  ? iOS26Colors.accentBlue.withOpacity(0.6)
                  : iOS26Colors.borderPrimary.withOpacity(0.4),
              width: _isFocused || hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.lock,
                color: hasError
                    ? iOS26Colors.accentRed
                    : _isFocused
                    ? iOS26Colors.accentBlue
                    : iOS26Colors.textTertiary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: !widget.isVisible.value,
                  style: const TextStyle(
                    color: iOS26Colors.textPrimary,
                    fontSize: 15,
                  ),
                  cursorColor: iOS26Colors.accentBlue,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      color: iOS26Colors.textTertiary,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    filled: false,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16),
                    isCollapsed: true,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _errorText = error);
                    });
                    return error;
                  },
                ),
              ),
              GestureDetector(
                onTap: widget.onToggle,
                child: Icon(
                  widget.isVisible.value ? Iconsax.eye : Iconsax.eye_slash,
                  color: iOS26Colors.textTertiary,
                  size: 20,
                ),
              ),
            ],
          ),
        )),
        // Error Text
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 8),
            child: Row(
              children: [
                const Icon(
                  Iconsax.warning_2,
                  color: iOS26Colors.accentRed,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _errorText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: iOS26Colors.accentRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Register Button
class _RegisterButton extends StatelessWidget {
  final AuthController controller;

  const _RegisterButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: controller.isLoading.value
          ? null
          : () {
        HapticFeedback.mediumImpact();
        controller.register();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: controller.isLoading.value
              ? null
              : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              iOS26Colors.accentBlue,
              iOS26Colors.accentIndigo,
            ],
          ),
          color: controller.isLoading.value
              ? iOS26Colors.surfaceGlass
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: controller.isLoading.value
              ? null
              : [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: controller.isLoading.value
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: iOS26Colors.textSecondary,
              strokeWidth: 2.5,
            ),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.user_add,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'إنشاء الحساب',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

/// Login Link
class _LoginLink extends StatelessWidget {
  final AuthController controller;

  const _LoginLink({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'لديك حساب بالفعل؟',
            style: TextStyle(
              color: iOS26Colors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              controller.goToLogin();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: iOS26Colors.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  color: iOS26Colors.accentBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}