import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/users_controller.dart';
import '../../data/models/user_model.dart';
import '../../utils/helpers.dart';
import '../../routes/app_routes.dart';

/// iOS 26 Inspired Users View
class UsersView extends GetView<UsersController> {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: _iOS26FAB(
          onTap: () => Get.toNamed(AppRoutes.userForm),
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Header
              SliverToBoxAdapter(
                child: _iOS26Header(controller: controller),
              ),
              // Statistics Card
              SliverToBoxAdapter(
                child: _StatisticsCard(controller: controller),
              ),
              // Search Bar
              SliverToBoxAdapter(
                child: _SearchSection(controller: controller),
              ),
              // Filter Chips
              SliverToBoxAdapter(
                child: _FilterChipsRow(controller: controller),
              ),
            ];
          },
          body: _UsersListBody(controller: controller),
        ),
      ),
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

  static const Color textPrimary = Color(0xFFE5E5E7);
  static const Color textSecondary = Color(0xFF98989F);
  static const Color textTertiary = Color(0xFF636366);

  static const Color borderPrimary = Color(0xFF38383A);
}

/// iOS 26 Header
class _iOS26Header extends StatelessWidget {
  final UsersController controller;

  const _iOS26Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المستخدمين',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: iOS26Colors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          _FilterButton(
            onTap: () => _showFilterSheet(context),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _iOS26FilterSheet(controller: controller),
    );
  }
}

/// Filter Button
class _FilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();

    return Obx(() {
      final hasFilters = controller.userTypeFilter.value != null;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: hasFilters
                ? iOS26Colors.accentBlue.withOpacity(0.15)
                : iOS26Colors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasFilters
                  ? iOS26Colors.accentBlue.withOpacity(0.3)
                  : iOS26Colors.borderPrimary.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Iconsax.filter,
                color: hasFilters
                    ? iOS26Colors.accentBlue
                    : iOS26Colors.textSecondary,
                size: 20,
              ),
              if (hasFilters)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: iOS26Colors.accentBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

/// Statistics Card
class _StatisticsCard extends StatelessWidget {
  final UsersController controller;

  const _StatisticsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.statistics.value;
      if (stats == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A5F),
              Color(0xFF0F2744),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: iOS26Colors.accentBlue.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: 'الإجمالي',
              value: stats.totalUsers,
              icon: Iconsax.people,
              color: iOS26Colors.accentBlue,
            ),
            _StatDivider(),
            _StatItem(
              label: 'النشطين',
              value: stats.activeUsers,
              icon: Iconsax.tick_circle,
              color: iOS26Colors.accentGreen,
            ),
            _StatDivider(),
            _StatItem(
              label: 'المواطنين',
              value: stats.citizensCount,
              icon: Iconsax.user,
              color: iOS26Colors.accentTeal,
            ),
            _StatDivider(),
            _StatItem(
              label: 'المسؤولين',
              value: stats.adminsCount,
              icon: Iconsax.shield_tick,
              color: iOS26Colors.accentPurple,
            ),
          ],
        ),
      );
    });
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          Helpers.formatNumber(value),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: iOS26Colors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: iOS26Colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: iOS26Colors.borderPrimary.withOpacity(0.3),
    );
  }
}

/// Search Section
class _SearchSection extends StatelessWidget {
  final UsersController controller;

  const _SearchSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: _iOS26SearchBar(controller: controller),
    );
  }
}

/// iOS 26 Search Bar
class _iOS26SearchBar extends StatefulWidget {
  final UsersController controller;

  const _iOS26SearchBar({required this.controller});

  @override
  State<_iOS26SearchBar> createState() => _iOS26SearchBarState();
}

class _iOS26SearchBarState extends State<_iOS26SearchBar> {
  bool _isFocused = false;
  late FocusNode _focusNode;

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
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isFocused
              ? iOS26Colors.accentBlue.withOpacity(0.6)
              : iOS26Colors.borderPrimary.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.search_normal,
            color: _isFocused
                ? iOS26Colors.accentBlue
                : iOS26Colors.textTertiary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller.searchController,
              focusNode: _focusNode,
              onChanged: widget.controller.setSearchQuery,
              style: const TextStyle(
                color: iOS26Colors.textPrimary,
                fontSize: 15,
              ),
              cursorColor: iOS26Colors.accentBlue,
              decoration: const InputDecoration(
                hintText: 'بحث في المستخدمين...',
                hintStyle: TextStyle(
                  color: iOS26Colors.textTertiary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
              ),
            ),
          ),
          Obx(() {
            if (widget.controller.searchQuery.value.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.controller.searchController.clear();
                  widget.controller.setSearchQuery('');
                },
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: iOS26Colors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 12,
                    color: iOS26Colors.backgroundPrimary,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

/// Filter Chips Row
class _FilterChipsRow extends StatelessWidget {
  final UsersController controller;

  const _FilterChipsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userTypeFilter.value == null) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _FilterChip(
              label: controller.userTypeFilter.value == 'admin' ? 'مسؤول' : 'مواطن',
              color: iOS26Colors.accentBlue,
              onDelete: () => controller.setUserTypeFilter(null),
            ),
            const SizedBox(width: 8),
            _ClearAllButton(onTap: controller.clearFilters),
          ],
        ),
      );
    });
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onDelete;

  const _FilterChip({
    required this.label,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onDelete();
            },
            child: Icon(Icons.close, size: 16, color: color),
          ),
        ],
      ),
    );
  }
}

class _ClearAllButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearAllButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: iOS26Colors.accentRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear_all, size: 16, color: iOS26Colors.accentRed),
            SizedBox(width: 4),
            Text(
              'مسح',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: iOS26Colors.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Users List Body
class _UsersListBody extends StatelessWidget {
  final UsersController controller;

  const _UsersListBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.users.isEmpty) {
        return const _LoadingState();
      }

      if (controller.users.isEmpty) {
        return _EmptyState(onRefresh: controller.refreshUsers);
      }

      return RefreshIndicator(
        onRefresh: controller.refreshUsers,
        color: iOS26Colors.accentBlue,
        backgroundColor: iOS26Colors.surfaceElevated,
        child: ListView.builder(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 160),
          itemCount: controller.users.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.users.length) {
              return const _LoadMoreIndicator();
            }
            return _UserCard(user: controller.users[index]);
          },
        ),
      );
    });
  }
}

/// User Card
class _UserCard extends StatelessWidget {
  final UserModel user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(AppRoutes.userDetails, arguments: {'id': user.id});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: iOS26Colors.borderPrimary.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            _UserAvatar(user: user),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: iOS26Colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.rationalId,
                    style: const TextStyle(
                      fontSize: 13,
                      color: iOS26Colors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.call,
                        size: 12,
                        color: iOS26Colors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.phone,
                        style: const TextStyle(
                          fontSize: 12,
                          color: iOS26Colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _UserTypeBadge(userType: user.userType),
                const SizedBox(height: 8),
                _ActiveBadge(isActive: user.isActive),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// User Avatar
class _UserAvatar extends StatelessWidget {
  final UserModel user;

  const _UserAvatar({required this.user});

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.userType == 'admin';
    final color = isAdmin ? iOS26Colors.accentPurple : iOS26Colors.accentBlue;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: user.profileImageUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(13),
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
          fontSize: 20,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// iOS 26 Filter Sheet
class _iOS26FilterSheet extends StatelessWidget {
  final UsersController controller;

  const _iOS26FilterSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: const BoxDecoration(
        color: iOS26Colors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: iOS26Colors.borderPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تصفية المستخدمين',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: iOS26Colors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      controller.clearFilters();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: iOS26Colors.accentRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'مسح الكل',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: iOS26Colors.accentRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // User Type Section
            _FilterSection(
              title: 'نوع المستخدم',
              child: Obx(() => Row(
                children: [
                  Expanded(
                    child: _FilterOption(
                      label: 'مواطن',
                      icon: Iconsax.user,
                      color: iOS26Colors.accentTeal,
                      isSelected: controller.userTypeFilter.value == 'citizen',
                      onTap: () => controller.setUserTypeFilter(
                        controller.userTypeFilter.value == 'citizen'
                            ? null
                            : 'citizen',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FilterOption(
                      label: 'مسؤول',
                      icon: Iconsax.shield_tick,
                      color: iOS26Colors.accentPurple,
                      isSelected: controller.userTypeFilter.value == 'admin',
                      onTap: () => controller.setUserTypeFilter(
                        controller.userTypeFilter.value == 'admin'
                            ? null
                            : 'admin',
                      ),
                    ),
                  ),
                ],
              )),
            ),

            const SizedBox(height: 24),

            // Apply Button
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 20),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [iOS26Colors.accentBlue, iOS26Colors.accentIndigo],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: iOS26Colors.accentBlue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'تطبيق الفلتر',
                      style: TextStyle(
                        fontSize: 16,
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
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: iOS26Colors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : iOS26Colors.surfaceGlass,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.5)
                : iOS26Colors.borderPrimary.withOpacity(0.3),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? color : iOS26Colors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : iOS26Colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// iOS 26 FAB
class _iOS26FAB extends StatelessWidget {
  final VoidCallback onTap;

  const _iOS26FAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [iOS26Colors.accentBlue, iOS26Colors.accentIndigo],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
          size: 26,
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
            'جاري تحميل المستخدمين...',
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

/// Empty State
class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
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
                Iconsax.people,
                color: iOS26Colors.textTertiary,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا يوجد مستخدمين',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لم يتم العثور على أي مستخدمين',
              style: TextStyle(
                fontSize: 15,
                color: iOS26Colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onRefresh();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: iOS26Colors.accentBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.refresh,
                      size: 18,
                      color: iOS26Colors.accentBlue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'تحديث',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: iOS26Colors.accentBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Load More Indicator
class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: iOS26Colors.accentBlue,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}