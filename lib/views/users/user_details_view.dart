import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/users_controller.dart';
import '../../utils/helpers.dart';
import '../../routes/app_routes.dart';

/// iOS 26 Inspired User Details View
class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  final controller = Get.find<UsersController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      final userId = args?['id'] as String?;

      if (userId != null && controller.selectedUser.value?.id != userId) {
        controller.loadUserDetails(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: Obx(() {
        if (controller.isLoading.value && controller.selectedUser.value == null) {
          return const _LoadingState();
        }

        final user = controller.selectedUser.value;
        if (user == null) {
          return const _NotFoundState();
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _iOS26Header(
                user: user,
                onMenuAction: _handleMenuAction,
              ),
            ),
            // Content
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Card
                  _ProfileCard(user: user),
                  const SizedBox(height: 20),

                  // Info Card
                  _InfoCard(user: user),
                  const SizedBox(height: 20),

                  // Actions Card
                  _ActionsCard(
                    user: user,
                    onEdit: () {
                      controller.prepareForEdit(user);
                      Get.toNamed(AppRoutes.userForm, arguments: {'user': user});
                    },
                    onToggle: () => controller.toggleUserActive(user.id!),
                    onDelete: () => _showDeleteConfirmation(user.id!),
                  ),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _handleMenuAction(String action) {
    final user = controller.selectedUser.value;
    if (user == null) return;

    switch (action) {
      case 'edit':
        controller.prepareForEdit(user);
        Get.toNamed(AppRoutes.userForm, arguments: {'user': user});
        break;
      case 'toggle':
        controller.toggleUserActive(user.id!);
        break;
      case 'delete':
        _showDeleteConfirmation(user.id!);
        break;
    }
  }

  void _showDeleteConfirmation(String id) {
    HapticFeedback.mediumImpact();
    Get.dialog(
      _DeleteConfirmationDialog(
        onConfirm: () {
          Get.back();
          controller.deleteUser(id, hard: true);
        },
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
  static const Color accentYellow = Color(0xFFFFD60A);

  static const Color textPrimary = Color(0xFFE5E5E7);
  static const Color textSecondary = Color(0xFF98989F);
  static const Color textTertiary = Color(0xFF636366);

  static const Color borderPrimary = Color(0xFF38383A);
}

/// iOS 26 Header
class _iOS26Header extends StatelessWidget {
  final dynamic user;
  final Function(String) onMenuAction;

  const _iOS26Header({
    required this.user,
    required this.onMenuAction,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
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
            const SizedBox(width: 12),
            // Title
            const Expanded(
              child: Text(
                'تفاصيل المستخدم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
            ),
            // Menu Button
            _MenuButton(onAction: onMenuAction),
          ],
        ),
      ),
    );
  }
}

/// Menu Button
class _MenuButton extends StatelessWidget {
  final Function(String) onAction;

  const _MenuButton({required this.onAction});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        HapticFeedback.lightImpact();
        onAction(value);
      },
      icon: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Iconsax.more,
          color: iOS26Colors.textSecondary,
          size: 20,
        ),
      ),
      color: iOS26Colors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
        ),
      ),
      itemBuilder: (context) => [
        _buildMenuItem('edit', Iconsax.edit, 'تعديل', iOS26Colors.accentBlue),
        _buildMenuItem('toggle', Iconsax.user_tick, 'تفعيل/تعطيل', iOS26Colors.accentOrange),
        _buildMenuItem('delete', Iconsax.trash, 'حذف نهائي', iOS26Colors.accentRed),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, IconData icon, String label, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: value == 'delete' ? color : iOS26Colors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A5F), Color(0xFF0F2744)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: iOS26Colors.accentBlue.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          _UserAvatar(user: user, isAdmin: isAdmin),
          const SizedBox(height: 20),

          // Name
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: iOS26Colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),

          // Rational ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: iOS26Colors.accentBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              user.rationalId,
              style: const TextStyle(
                fontSize: 13,
                color: iOS26Colors.accentBlue,
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _UserTypeBadge(userType: user.userType),
              const SizedBox(width: 12),
              _ActiveBadge(isActive: user.isActive),
            ],
          ),
        ],
      ),
    );
  }
}

/// User Avatar
class _UserAvatar extends StatelessWidget {
  final dynamic user;
  final bool isAdmin;

  const _UserAvatar({required this.user, required this.isAdmin});

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
          width: 3,
        ),
      ),
      child: user.profileImageUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(25),
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
    final label = isAdmin ? 'مسؤول' : 'مواطن';
    final icon = isAdmin ? Iconsax.shield_tick : Iconsax.user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
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

/// Active Badge
class _ActiveBadge extends StatelessWidget {
  final bool isActive;

  const _ActiveBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? iOS26Colors.accentGreen : iOS26Colors.accentRed;
    final label = isActive ? 'نشط' : 'معطل';
    final icon = isActive ? Iconsax.tick_circle : Iconsax.close_circle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
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

/// Info Card
class _InfoCard extends StatelessWidget {
  final dynamic user;

  const _InfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iOS26Colors.accentBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.personalcard,
                  size: 18,
                  color: iOS26Colors.accentBlue,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'المعلومات الشخصية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Phone
          _InfoRow(
            icon: Iconsax.call,
            label: 'رقم الهاتف',
            value: user.phone,
            color: iOS26Colors.accentGreen,
          ),
          _InfoDivider(),

          // Created At
          _InfoRow(
            icon: Iconsax.calendar,
            label: 'تاريخ الإنشاء',
            value: Helpers.formatDateTime(user.createdAt),
            color: iOS26Colors.accentOrange,
          ),

          // Updated At
          if (user.updatedAt != null) ...[
            _InfoDivider(),
            _InfoRow(
              icon: Iconsax.refresh,
              label: 'آخر تحديث',
              value: Helpers.formatDateTime(user.updatedAt),
              color: iOS26Colors.accentIndigo,
            ),
          ],
        ],
      ),
    );
  }
}

/// Info Row
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
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
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: iOS26Colors.textPrimary,
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

/// Info Divider
class _InfoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 54),
      height: 0.5,
      color: iOS26Colors.borderPrimary.withOpacity(0.4),
    );
  }
}

/// Actions Card
class _ActionsCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ActionsCard({
    required this.user,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iOS26Colors.accentIndigo.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.setting_2,
                  size: 18,
                  color: iOS26Colors.accentIndigo,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'الإجراءات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Edit Button
          _ActionButton(
            icon: Iconsax.edit,
            label: 'تعديل البيانات',
            color: iOS26Colors.accentBlue,
            onTap: onEdit,
          ),
          const SizedBox(height: 12),

          // Toggle Button
          _ActionButton(
            icon: user.isActive ? Iconsax.user_remove : Iconsax.user_tick,
            label: user.isActive ? 'تعطيل الحساب' : 'تفعيل الحساب',
            color: user.isActive ? iOS26Colors.accentOrange : iOS26Colors.accentGreen,
            onTap: onToggle,
          ),
          const SizedBox(height: 12),

          // Delete Button
          _ActionButton(
            icon: Iconsax.trash,
            label: 'حذف نهائي',
            color: iOS26Colors.accentRed,
            onTap: onDelete,
            isDanger: true,
          ),
        ],
      ),
    );
  }
}

/// Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDanger;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(isDanger ? 0.12 : 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Row(
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
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: color.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// Delete Confirmation Dialog
class _DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _DeleteConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                Iconsax.trash,
                color: iOS26Colors.accentRed,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'حذف المستخدم',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'هل أنت متأكد من حذف هذا المستخدم نهائياً؟\nلا يمكن التراجع عن هذا الإجراء.',
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
                      HapticFeedback.mediumImpact();
                      onConfirm();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: iOS26Colors.accentRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'حذف نهائي',
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
    );
  }
}

/// Loading State
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: iOS26Colors.accentBlue,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              color: iOS26Colors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Not Found State
class _NotFoundState extends StatelessWidget {
  const _NotFoundState();

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
            'لم يتم العثور على المستخدم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: iOS26Colors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: iOS26Colors.accentBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'رجوع',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.accentBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}