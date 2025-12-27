import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/helpers.dart';

/// iOS 26 Inspired Login View
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Logo & Header
                      _LogoSection(),
                      const SizedBox(height: 50),

                      // Welcome Text
                      _WelcomeText(),
                      const SizedBox(height: 40),

                      // Login Form Card
                      _LoginFormCard(controller: controller),
                      const SizedBox(height: 24),

                      // Login Button
                      _LoginButton(controller: controller),
                      const SizedBox(height: 32),

                      // Divider
                      _OrDivider(),
                      const SizedBox(height: 32),

                      // Register Link
                      _RegisterLink(controller: controller),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
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
            center: const Alignment(0, -0.5),
            radius: 1.5,
            colors: [
              iOS26Colors.accentBlue.withOpacity(0.15),
              iOS26Colors.backgroundPrimary,
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo Section
class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A5F),
              Color(0xFF0F2744),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: iOS26Colors.accentBlue.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Iconsax.shield_tick5,
          size: 48,
          color: iOS26Colors.accentBlue,
        ),
      ),
    );
  }
}

/// Welcome Text
class _WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مرحباً بك 👋',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: iOS26Colors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سجل دخولك للوصول إلى لوحة التحكم',
          style: TextStyle(
            fontSize: 16,
            color: iOS26Colors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Login Form Card
class _LoginFormCard extends StatelessWidget {
  final AuthController controller;

  const _LoginFormCard({required this.controller});

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
          // Rational ID Field
          _iOS26TextField(
            controller: controller.rationalIdController,
            label: 'الرقم الوطني',
            hint: 'أدخل الرقم الوطني',
            icon: Iconsax.personalcard,
            keyboardType: TextInputType.number,
            validator: (value) => Helpers.validateRationalId(value),
          ),
          const SizedBox(height: 20),

          // Password Field
          _iOS26PasswordField(controller: controller),
          const SizedBox(height: 20),

          // Remember Me
          _RememberMeCheckbox(controller: controller),
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
                Text(
                  _errorText!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: iOS26Colors.accentRed,
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
  final AuthController controller;

  const _iOS26PasswordField({required this.controller});

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
            'كلمة المرور',
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
                  controller: widget.controller.passwordController,
                  focusNode: _focusNode,
                  obscureText: !widget.controller.isPasswordVisible.value,
                  style: const TextStyle(
                    color: iOS26Colors.textPrimary,
                    fontSize: 15,
                  ),
                  cursorColor: iOS26Colors.accentBlue,
                  decoration: InputDecoration(
                    hintText: 'أدخل كلمة المرور',
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
                    final error = Helpers.validatePassword(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _errorText = error);
                    });
                    return error;
                  },
                ),
              ),
              GestureDetector(
                onTap: widget.controller.togglePasswordVisibility,
                child: Icon(
                  widget.controller.isPasswordVisible.value
                      ? Iconsax.eye
                      : Iconsax.eye_slash,
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
                Text(
                  _errorText!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: iOS26Colors.accentRed,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Remember Me Checkbox
class _RememberMeCheckbox extends StatelessWidget {
  final AuthController controller;

  const _RememberMeCheckbox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        controller.toggleRememberMe(!controller.rememberMe.value);
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: controller.rememberMe.value
                  ? iOS26Colors.accentBlue
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: controller.rememberMe.value
                    ? iOS26Colors.accentBlue
                    : iOS26Colors.borderPrimary,
                width: 1.5,
              ),
            ),
            child: controller.rememberMe.value
                ? const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(width: 10),
          const Text(
            'تذكرني',
            style: TextStyle(
              color: iOS26Colors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ));
  }
}

/// Login Button
class _LoginButton extends StatelessWidget {
  final AuthController controller;

  const _LoginButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: controller.isLoading.value
          ? null
          : () {
        HapticFeedback.mediumImpact();
        controller.login();
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
                Iconsax.login,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 10),
              Text(
                'تسجيل الدخول',
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

/// Or Divider
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            color: iOS26Colors.borderPrimary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'أو',
            style: TextStyle(
              color: iOS26Colors.textTertiary,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 0.5,
            color: iOS26Colors.borderPrimary,
          ),
        ),
      ],
    );
  }
}

/// Register Link
class _RegisterLink extends StatelessWidget {
  final AuthController controller;

  const _RegisterLink({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ليس لديك حساب؟',
            style: TextStyle(
              color: iOS26Colors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              controller.goToRegister();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: iOS26Colors.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'إنشاء حساب',
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