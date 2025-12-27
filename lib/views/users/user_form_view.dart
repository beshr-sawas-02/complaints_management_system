import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/users_controller.dart';
import '../../data/models/user_model.dart';
import '../../utils/helpers.dart';

/// iOS 26 Inspired User Form View
class UserFormView extends GetView<UsersController> {
  const UserFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final user = args?['user'] as UserModel?;
    final isEdit = user != null;

    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _iOS26Header(isEdit: isEdit),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Preview
                      _AvatarPreview(isEdit: isEdit),
                      const SizedBox(height: 32),

                      // Full Name
                      _iOS26TextField(
                        controller: controller.fullNameController,
                        label: 'الاسم الكامل',
                        hint: 'أدخل الاسم الكامل',
                        icon: Iconsax.user,
                        validator: (value) =>
                            Helpers.validateRequired(value, 'الاسم'),
                      ),
                      const SizedBox(height: 20),

                      // Rational ID
                      _iOS26TextField(
                        controller: controller.rationalIdController,
                        label: 'الرقم الوطني',
                        hint: 'أدخل الرقم الوطني',
                        icon: Iconsax.personalcard,
                        keyboardType: TextInputType.number,
                        enabled: !isEdit,
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
                      _iOS26TextField(
                        controller: controller.passwordController,
                        label: isEdit
                            ? 'كلمة المرور الجديدة (اختياري)'
                            : 'كلمة المرور',
                        hint: isEdit
                            ? 'اتركها فارغة إذا لم ترد التغيير'
                            : 'أدخل كلمة المرور',
                        icon: Iconsax.lock,
                        isPassword: true,
                        validator: isEdit
                            ? null
                            : (value) => Helpers.validatePassword(value),
                      ),
                      const SizedBox(height: 24),

                      // User Type Selector
                      _UserTypeSelector(controller: controller),
                      const SizedBox(height: 40),

                      // Submit Button
                      _SubmitButton(isEdit: isEdit, user: user),
                      const SizedBox(height: 16),

                      // Cancel Button
                      _CancelButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

/// iOS 26 Header
class _iOS26Header extends StatelessWidget {
  final bool isEdit;

  const _iOS26Header({required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      decoration: BoxDecoration(
        color: iOS26Colors.backgroundPrimary,
        border: Border(
          bottom: BorderSide(
            color: iOS26Colors.borderPrimary.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
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
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Text(
              isEdit ? 'تعديل المستخدم' : 'إضافة مستخدم',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar Preview
class _AvatarPreview extends StatelessWidget {
  final bool isEdit;

  const _AvatarPreview({required this.isEdit});

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
            colors: [Color(0xFF1E3A5F), Color(0xFF0F2744)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: iOS26Colors.accentBlue.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          isEdit ? Iconsax.user_edit5 : Iconsax.user_add5,
          color: iOS26Colors.accentBlue,
          size: 44,
        ),
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
  final bool isPassword;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _iOS26TextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_iOS26TextField> createState() => _iOS26TextFieldState();
}

class _iOS26TextFieldState extends State<_iOS26TextField> {
  bool _isFocused = false;
  bool _obscureText = true;
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
    final isDisabled = !widget.enabled;

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
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDisabled
                ? iOS26Colors.surfaceGlass.withOpacity(0.5)
                : iOS26Colors.surfaceElevated,
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
              // Icon
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
              // Text Field
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.isPassword ? _obscureText : false,
                  keyboardType: widget.keyboardType,
                  style: TextStyle(
                    color: isDisabled
                        ? iOS26Colors.textTertiary
                        : iOS26Colors.textPrimary,
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
                    disabledBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    isCollapsed: true,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() => _errorText = error);
                      }
                    });
                    return error;
                  },
                ),
              ),
              // Password Toggle
              if (widget.isPassword)
                GestureDetector(
                  onTap: () => setState(() => _obscureText = !_obscureText),
                  child: Icon(
                    _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                    color: iOS26Colors.textTertiary,
                    size: 20,
                  ),
                ),
              // Disabled indicator
              if (isDisabled)
                const Icon(
                  Iconsax.lock,
                  color: iOS26Colors.textTertiary,
                  size: 16,
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

/// User Type Selector
class _UserTypeSelector extends StatelessWidget {
  final UsersController controller;

  const _UserTypeSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 4, bottom: 12),
          child: Text(
            'نوع المستخدم',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: iOS26Colors.textSecondary,
            ),
          ),
        ),
        Obx(() => Row(
          children: [
            Expanded(
              child: _UserTypeOption(
                type: 'citizen',
                label: 'مواطن',
                icon: Iconsax.user,
                color: iOS26Colors.accentTeal,
                isSelected: controller.selectedUserType.value == 'citizen',
                onTap: () => controller.selectedUserType.value = 'citizen',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _UserTypeOption(
                type: 'admin',
                label: 'مسؤول',
                icon: Iconsax.shield_tick,
                color: iOS26Colors.accentPurple,
                isSelected: controller.selectedUserType.value == 'admin',
                onTap: () => controller.selectedUserType.value = 'admin',
              ),
            ),
          ],
        )),
      ],
    );
  }
}

/// User Type Option
class _UserTypeOption extends StatelessWidget {
  final String type;
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserTypeOption({
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : iOS26Colors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.5)
                : iOS26Colors.borderPrimary.withOpacity(0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.2)
                    : iOS26Colors.surfaceGlass,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? color : iOS26Colors.textTertiary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : iOS26Colors.textSecondary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Icon(
                Iconsax.tick_circle5,
                size: 20,
                color: color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Submit Button
class _SubmitButton extends StatelessWidget {
  final bool isEdit;
  final UserModel? user;

  const _SubmitButton({
    required this.isEdit,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();

    return Obx(() {
      final isLoading =
      isEdit ? controller.isUpdating.value : controller.isCreating.value;

      return GestureDetector(
        onTap: isLoading
            ? null
            : () {
          HapticFeedback.mediumImpact();
          if (isEdit) {
            controller.updateUser(user!.id!);
          } else {
            controller.createUser();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: isLoading
                ? null
                : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [iOS26Colors.accentBlue, iOS26Colors.accentIndigo],
            ),
            color: isLoading ? iOS26Colors.surfaceGlass : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isLoading
                ? null
                : [
              BoxShadow(
                color: iOS26Colors.accentBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: iOS26Colors.textSecondary,
                strokeWidth: 2.5,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEdit ? Iconsax.tick_circle : Iconsax.user_add,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  isEdit ? 'حفظ التغييرات' : 'إنشاء المستخدم',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// Cancel Button
class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.back();
      },
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: iOS26Colors.borderPrimary.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'إلغاء',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: iOS26Colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}