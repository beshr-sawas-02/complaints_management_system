import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../utils/helpers.dart';
import '../../utils/storage_service.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  File? _selectedImage;
  bool _isLoading = false;
  bool _removeImage = false;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final user = _authController.currentUser.value;
    if (user != null) {
      _nameController.text = user.fullName;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Profile Image
                      _buildProfileImage(),
                      const SizedBox(height: 32),

                      // Form Card
                      _buildFormCard(),
                      const SizedBox(height: 24),

                      // Read Only Info
                      _buildReadOnlyCard(),
                      const SizedBox(height: 32),

                      // Save Button
                      _buildSaveButton(),
                      const SizedBox(height: 16),

                      // Cancel Button
                      _buildCancelButton(),
                      const SizedBox(height: 40),
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

  Widget _buildHeader() {
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
          const Expanded(
            child: Text(
              'تعديل الملف الشخصي',
              style: TextStyle(
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

  Widget _buildProfileImage() {
    final user = _authController.currentUser.value;
    final isAdmin = user?.userType == 'admin';
    final color = isAdmin ? iOS26Colors.accentPurple : iOS26Colors.accentTeal;

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: color.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: _buildImageContent(user, color),
            ),
          ),

          // Edit Button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImagePicker,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [iOS26Colors.accentBlue, iOS26Colors.accentIndigo],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iOS26Colors.accentBlue.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.camera,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent(UserModel? user, Color color) {
    if (_removeImage) {
      return _buildPlaceholder(color);
    }

    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
      );
    }

    if (user?.profileImageUrl != null) {
      return Image.network(
        Helpers.getImageUrl(user!.profileImageUrl),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(color),
      );
    }

    return _buildPlaceholder(color);
  }

  Widget _buildPlaceholder(Color color) {
    final user = _authController.currentUser.value;
    return Center(
      child: Text(
        user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'U',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Name Field
          _iOS26TextField(
            controller: _nameController,
            label: 'الاسم الكامل',
            hint: 'أدخل الاسم الكامل',
            icon: Iconsax.user,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال الاسم';
              }
              if (value.length < 3) {
                return 'الاسم يجب أن يكون 3 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Field
          _iOS26TextField(
            controller: _phoneController,
            label: 'رقم الهاتف',
            hint: 'أدخل رقم الهاتف',
            icon: Iconsax.call,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 10) {
                return 'رقم الهاتف غير صحيح';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyCard() {
    final user = _authController.currentUser.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Rational ID
          _ReadOnlyField(
            icon: Iconsax.card,
            label: 'الرقم الوطني',
            value: user?.rationalId ?? '',
          ),
          const _FieldDivider(),

          // User Type
          _ReadOnlyField(
            icon: Iconsax.shield_tick,
            label: 'نوع الحساب',
            value: user?.userType == 'admin' ? 'مسؤول النظام' : 'مواطن',
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _saveProfile,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: _isLoading
              ? null
              : const LinearGradient(
            colors: [iOS26Colors.accentBlue, iOS26Colors.accentIndigo],
          ),
          color: _isLoading ? iOS26Colors.surfaceGlass : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isLoading
              ? null
              : [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
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
                Iconsax.tick_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'حفظ التغييرات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.back();
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: iOS26Colors.borderPrimary.withOpacity(0.4),
          ),
        ),
        child: const Center(
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: iOS26Colors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePicker() {
    HapticFeedback.lightImpact();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: iOS26Colors.surfaceElevated,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: iOS26Colors.borderPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'تغيير الصورة الشخصية',
              style: TextStyle(
                color: iOS26Colors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Camera Option
            _ImageOption(
              icon: Iconsax.camera,
              title: 'التقاط صورة',
              color: iOS26Colors.accentBlue,
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 12),

            // Gallery Option
            _ImageOption(
              icon: Iconsax.gallery,
              title: 'اختيار من المعرض',
              color: iOS26Colors.accentPurple,
              onTap: () => _pickImage(ImageSource.gallery),
            ),

            if (_selectedImage != null ||
                (!_removeImage && _authController.currentUser.value?.profileImageUrl != null)) ...[
              const SizedBox(height: 12),
              // Remove Option
              _ImageOption(
                icon: Iconsax.trash,
                title: 'إزالة الصورة',
                color: iOS26Colors.accentRed,
                onTap: () {
                  setState(() {
                    _selectedImage = null;
                    _removeImage = true;
                  });
                  Get.back();
                },
              ),
            ],

            SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Get.back();

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _removeImage = false;
        });
      }
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ في اختيار الصورة');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();

    setState(() => _isLoading = true);

    try {
      UserModel? updatedUser;

      // 1. Upload image if selected
      if (_selectedImage != null) {
        updatedUser = await _userRepository.uploadProfileImage(_selectedImage!.path);
      }

      // 2. Remove image if requested
      if (_removeImage) {
        // TODO: Add remove image API call if needed
      }

      // 3. Update profile data
      final data = {
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      updatedUser = await _userRepository.updateCurrentUser(data);

      // 4. Update local user data
      _authController.currentUser.value = updatedUser;

      // 5. Save to local storage
      await StorageService.saveUser(updatedUser);

      // 6. Force refresh the auth controller to update UI
      _authController.currentUser.refresh();

      Helpers.showSuccessSnackbar('تم تحديث الملف الشخصي بنجاح');

      // 7. Go back with result to trigger refresh in previous screen
      Get.back(result: true);

    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
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

/// Read Only Field
class _ReadOnlyField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReadOnlyField({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iOS26Colors.surfaceGlass,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iOS26Colors.textTertiary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: iOS26Colors.textTertiary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: iOS26Colors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: iOS26Colors.surfaceGlass,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.lock,
                  size: 10,
                  color: iOS26Colors.textTertiary,
                ),
                const SizedBox(width: 4),
                const Text(
                  'محمي',
                  style: TextStyle(
                    color: iOS26Colors.textTertiary,
                    fontSize: 10,
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

/// Field Divider
class _FieldDivider extends StatelessWidget {
  const _FieldDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 54),
      height: 0.5,
      color: iOS26Colors.borderPrimary.withOpacity(0.4),
    );
  }
}

/// Image Option
class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ImageOption({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: iOS26Colors.borderPrimary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: iOS26Colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: iOS26Colors.textTertiary,
              size: 16,
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
  static const Color accentRed = Color(0xFFFF453A);

  static const Color textPrimary = Color(0xFFE5E5E7);
  static const Color textSecondary = Color(0xFF98989F);
  static const Color textTertiary = Color(0xFF636366);

  static const Color borderPrimary = Color(0xFF38383A);
}