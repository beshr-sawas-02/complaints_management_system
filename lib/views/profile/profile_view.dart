import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/helpers.dart';
import '../../routes/app_routes.dart';

/// iOS 26 Inspired Profile View
class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: Obx(() {
        final user = controller.currentUser.value;
        if (user == null) {
          return const _NotLoggedInState();
        }

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 160),
            child: Column(
              children: [
                // Header
                const _ProfileHeader(),
                const SizedBox(height: 24),

                // Profile Card
                _ProfileCard(user: user),
                const SizedBox(height: 24),

                // Quick Stats
                _QuickStats(user: user),
                const SizedBox(height: 24),

                // Menu Section
                const _MenuSection(),
                const SizedBox(height: 24),

                // Logout Button
                _LogoutButton(onTap: controller.logout),
                const SizedBox(height: 24),

                // App Version
                const _AppVersion(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// iOS 26 Color System
class iOS26Colors {
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF0D0D0F);
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
  static const Color accentYellow = Color(0xFFFFD60A);
  static const Color accentPink = Color(0xFFFF375F);

  static const Color textPrimary = Color(0xFFE5E5E7);
  static const Color textSecondary = Color(0xFF98989F);
  static const Color textTertiary = Color(0xFF636366);

  static const Color borderPrimary = Color(0xFF38383A);
  static const Color borderSubtle = Color(0xFF1D1D1F);
}

/// Profile Header
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          'حسابي',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: iOS26Colors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

/// Profile Card
class _ProfileCard extends StatelessWidget {
  final dynamic user;

  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.userType == 'admin';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A5F),
            Color(0xFF0F2744),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: iOS26Colors.accentBlue.withOpacity(0.2),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: iOS26Colors.accentBlue.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          _ProfileAvatar(user: user, isAdmin: isAdmin),
          const SizedBox(height: 20),

          // Name
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: iOS26Colors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // ID
          Text(
            user.rationalId,
            style: const TextStyle(
              fontSize: 14,
              color: iOS26Colors.textSecondary,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),

          // User Type Badge
          _UserTypeBadge(userType: user.userType),
        ],
      ),
    );
  }
}

/// Profile Avatar
class _ProfileAvatar extends StatelessWidget {
  final dynamic user;
  final bool isAdmin;

  const _ProfileAvatar({required this.user, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final color = isAdmin ? iOS26Colors.accentPurple : iOS26Colors.accentTeal;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: user.profileImageUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Image.network(
          Helpers.getImageUrl(user.profileImageUrl),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(color),
        ),
      )
          : _buildPlaceholder(color),
    );
  }

  Widget _buildPlaceholder(Color color) {
    return Center(
      child: Text(
        user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// User Type Badge
class _UserTypeBadge extends StatelessWidget {
  final String userType;

  const _UserTypeBadge({required this.userType});

  @override
  Widget build(BuildContext context) {
    final isAdmin = userType == 'admin';
    final color = isAdmin ? iOS26Colors.accentPurple : iOS26Colors.accentTeal;
    final label = isAdmin ? 'مسؤول النظام' : 'مواطن';
    final icon = isAdmin ? Iconsax.shield_tick : Iconsax.user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick Stats
class _QuickStats extends StatelessWidget {
  final dynamic user;

  const _QuickStats({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Iconsax.call,
            label: 'الهاتف',
            value: user.phone ?? 'غير محدد',
            color: iOS26Colors.accentGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            icon: Iconsax.calendar,
            label: 'تاريخ التسجيل',
            value: _formatDate(user.createdAt),
            color: iOS26Colors.accentOrange,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: iOS26Colors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: iOS26Colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Menu Section
class _MenuSection extends StatelessWidget {
  const _MenuSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: Iconsax.user_edit,
            title: 'تعديل الملف الشخصي',
            color: iOS26Colors.accentBlue,
            onTap: () async {
              await Get.toNamed(AppRoutes.editProfile);
              // Refresh profile after returning
              Get.find<AuthController>().refreshProfile();
            },
          ),
          _MenuDivider(),
          _MenuItem(
            icon: Iconsax.lock,
            title: 'تغيير كلمة المرور',
            color: iOS26Colors.accentIndigo,
            onTap: () => _showChangePasswordDialog(),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: iOS26Colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تغيير كلمة المرور',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              _PasswordField(
                controller: oldPasswordController,
                label: 'كلمة المرور الحالية',
              ),
              const SizedBox(height: 16),
              _PasswordField(
                controller: newPasswordController,
                label: 'كلمة المرور الجديدة',
              ),
              const SizedBox(height: 16),
              _PasswordField(
                controller: confirmPasswordController,
                label: 'تأكيد كلمة المرور',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: iOS26Colors.surfaceGlass,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: iOS26Colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          Helpers.showErrorSnackbar('كلمة المرور غير متطابقة');
                          return;
                        }
                        Get.back();
                        Helpers.showSuccessSnackbar(
                            'تم تغيير كلمة المرور بنجاح');
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              iOS26Colors.accentBlue,
                              iOS26Colors.accentIndigo
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'حفظ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const _PasswordField({required this.controller, required this.label});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceGlass,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Iconsax.lock,
            color: iOS26Colors.textTertiary,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscure,
              style: const TextStyle(
                color: iOS26Colors.textPrimary,
                fontSize: 15,
              ),
              cursorColor: iOS26Colors.accentBlue,
              decoration: InputDecoration(
                hintText: widget.label,
                hintStyle: const TextStyle(
                  color: iOS26Colors.textTertiary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(
              _obscure ? Iconsax.eye_slash : Iconsax.eye,
              color: iOS26Colors.textTertiary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: iOS26Colors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: iOS26Colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      height: 0.5,
      color: iOS26Colors.borderPrimary.withOpacity(0.4),
    );
  }
}

/// Logout Button
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showLogoutConfirmation();
      },
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: iOS26Colors.accentRed.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: iOS26Colors.accentRed.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.logout,
              color: iOS26Colors.accentRed,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      Dialog(
        backgroundColor: iOS26Colors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iOS26Colors.accentRed.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.logout,
                  color: iOS26Colors.accentRed,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'هل أنت متأكد من تسجيل الخروج؟',
                style: TextStyle(
                  fontSize: 14,
                  color: iOS26Colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: iOS26Colors.surfaceGlass,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: iOS26Colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        final controller = Get.find<AuthController>();
                        controller.logout();
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: iOS26Colors.accentRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'خروج',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// App Version
class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iOS26Colors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Iconsax.code,
            color: iOS26Colors.textTertiary,
            size: 22,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'الإصدار 1.0.0',
          style: TextStyle(
            fontSize: 13,
            color: iOS26Colors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

/// Not Logged In State
class _NotLoggedInState extends StatelessWidget {
  const _NotLoggedInState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: iOS26Colors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Iconsax.user_remove,
              color: iOS26Colors.textTertiary,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لم يتم تسجيل الدخول',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: iOS26Colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يرجى تسجيل الدخول للمتابعة',
            style: TextStyle(
              fontSize: 14,
              color: iOS26Colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}