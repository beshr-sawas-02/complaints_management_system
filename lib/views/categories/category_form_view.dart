import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/categories_controller.dart';
import '../../data/models/category_model.dart';
import '../../utils/helpers.dart';

/// iOS 26 Inspired Category Form View
class CategoryFormView extends GetView<CategoriesController> {
  const CategoryFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final category = args?['category'] as CategoryModel?;
    final isEdit = category != null;

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
                      // Icon Preview
                      _CategoryIconPreview(isEdit: isEdit),
                      const SizedBox(height: 32),

                      // Category Name Field
                      _iOS26TextField(
                        controller: controller.complaintItemController,
                        label: 'اسم التصنيف',
                        hint: 'أدخل اسم التصنيف',
                        icon: Iconsax.folder,
                        validator: (value) =>
                            Helpers.validateRequired(value, 'اسم التصنيف'),
                      ),
                      const SizedBox(height: 20),

                      // Description Field
                      _iOS26TextField(
                        controller: controller.descriptionController,
                        label: 'الوصف',
                        hint: 'أدخل وصف التصنيف',
                        icon: Iconsax.document_text,
                        maxLines: 4,
                        validator: (value) =>
                            Helpers.validateRequired(value, 'الوصف'),
                      ),
                      const SizedBox(height: 40),

                      // Submit Button
                      _SubmitButton(
                        isEdit: isEdit,
                        category: category,
                      ),
                      const SizedBox(height: 20),

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
              isEdit ? 'تعديل التصنيف' : 'إضافة تصنيف',
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

/// Category Icon Preview
class _CategoryIconPreview extends StatelessWidget {
  final bool isEdit;

  const _CategoryIconPreview({required this.isEdit});

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
              color: iOS26Colors.accentBlue.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          isEdit ? Iconsax.edit5 : Iconsax.folder_add5,
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
  final int maxLines;
  final String? Function(String?)? validator;

  const _iOS26TextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
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
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: widget.maxLines > 1 ? 4 : 0,
          ),
          decoration: BoxDecoration(
            color: iOS26Colors.surfaceElevated,
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
            crossAxisAlignment: widget.maxLines > 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // Icon
              Padding(
                padding: EdgeInsets.only(
                  top: widget.maxLines > 1 ? 12 : 0,
                ),
                child: Icon(
                  widget.icon,
                  color: hasError
                      ? iOS26Colors.accentRed
                      : _isFocused
                      ? iOS26Colors.accentBlue
                      : iOS26Colors.textTertiary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Text Field
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  maxLines: widget.maxLines,
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
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: widget.maxLines > 1 ? 12 : 14,
                    ),
                    isCollapsed: widget.maxLines == 1,
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

/// Submit Button
class _SubmitButton extends StatelessWidget {
  final bool isEdit;
  final CategoryModel? category;

  const _SubmitButton({
    required this.isEdit,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoriesController>();

    return Obx(() {
      final isLoading =
      isEdit ? controller.isUpdating.value : controller.isCreating.value;

      return GestureDetector(
        onTap: isLoading
            ? null
            : () {
          HapticFeedback.mediumImpact();
          if (isEdit) {
            controller.updateCategory(category!.id!);
          } else {
            controller.createCategory();
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
                  isEdit ? Iconsax.tick_circle : Iconsax.add_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  isEdit ? 'حفظ التغييرات' : 'إنشاء التصنيف',
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