import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/complaints_controller.dart';
import '../../data/models/complaint_model.dart';
import '../../utils/helpers.dart';
import '../../routes/app_routes.dart';

/// iOS 26 Inspired Complaints View
class ComplaintsView extends GetView<ComplaintsController> {
  const ComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Header
              SliverToBoxAdapter(
                child: _iOS26Header(controller: controller),
              ),
              // Filter Chips
              SliverToBoxAdapter(
                child: _FilterChipsRow(controller: controller),
              ),
            ];
          },
          body: _ComplaintsListBody(controller: controller),
        ),
      ),
    );
  }
}

/// Complaints List Body
class _ComplaintsListBody extends StatelessWidget {
  final ComplaintsController controller;

  const _ComplaintsListBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.complaints.isEmpty) {
        return const _iOS26LoadingState();
      }

      if (controller.complaints.isEmpty) {
        return _iOS26EmptyState(
          onRefresh: controller.refreshComplaints,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshComplaints,
        color: iOS26Colors.accentBlue,
        backgroundColor: iOS26Colors.surfaceElevated,
        child: ListView.builder(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 160),
          itemCount: controller.complaints.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.complaints.length) {
              return const _LoadMoreIndicator();
            }
            return _iOS26ComplaintCard(
              complaint: controller.complaints[index],
              index: index,
            );
          },
        ),
      );
    });
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

  // Text - تم تغيير الألوان لتكون أكثر راحة للعين
  static const Color textPrimary = Color(0xFFE5E5E7);      // رمادي فاتح بدلاً من أبيض
  static const Color textSecondary = Color(0xFF98989F);    // رمادي متوسط
  static const Color textTertiary = Color(0xFF636366);     // رمادي غامق

  static const Color borderPrimary = Color(0xFF38383A);
  static const Color borderSubtle = Color(0xFF1D1D1F);

  static const Color statusPending = Color(0xFFFF9F0A);
  static const Color statusInProgress = Color(0xFF0A84FF);
  static const Color statusResolved = Color(0xFF30D158);
  static const Color statusClosed = Color(0xFF8E8E93);
}

/// iOS 26 Header with Search
class _iOS26Header extends StatelessWidget {
  final ComplaintsController controller;

  const _iOS26Header({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: iOS26Colors.backgroundPrimary,
        border: Border(
          bottom: BorderSide(
            color: iOS26Colors.borderPrimary.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الشكاوى',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: iOS26Colors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              // Filter Button
              _FilterButton(
                onTap: () => _showFilterSheet(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Search Bar
          _iOS26SearchBar(controller: controller),
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
    final controller = Get.find<ComplaintsController>();

    return Obx(() {
      final hasFilters = controller.statusFilter.value != null ||
          controller.priorityFilter.value != null;

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
                    decoration: BoxDecoration(
                      color: iOS26Colors.accentBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: iOS26Colors.accentBlue.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
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

/// iOS 26 Search Bar
class _iOS26SearchBar extends StatefulWidget {
  final ComplaintsController controller;

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
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
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
                hintText: 'بحث في الشكاوى...',
                hintStyle: TextStyle(
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
                  decoration: BoxDecoration(
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
  final ComplaintsController controller;

  const _FilterChipsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasFilters = controller.statusFilter.value != null ||
          controller.priorityFilter.value != null;

      if (!hasFilters) return const SizedBox.shrink();

      return Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            if (controller.statusFilter.value != null)
              _FilterChip(
                label: _getStatusText(controller.statusFilter.value!),
                color: _getStatusColor(controller.statusFilter.value!),
                onDelete: () => controller.setStatusFilter(null),
              ),
            if (controller.priorityFilter.value != null)
              _FilterChip(
                label: _getPriorityText(controller.priorityFilter.value!),
                color: _getPriorityColor(controller.priorityFilter.value!),
                onDelete: () => controller.setPriorityFilter(null),
              ),
            const SizedBox(width: 8),
            _ClearAllButton(
              onTap: controller.clearFilters,
            ),
          ],
        ),
      );
    });
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'in_progress':
        return 'قيد المعالجة';
      case 'resolved':
        return 'تم الحل';
      case 'closed':
        return 'مغلقة';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return iOS26Colors.statusPending;
      case 'in_progress':
        return iOS26Colors.statusInProgress;
      case 'resolved':
        return iOS26Colors.statusResolved;
      case 'closed':
        return iOS26Colors.statusClosed;
      default:
        return iOS26Colors.textSecondary;
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'low':
        return 'منخفضة';
      case 'medium':
        return 'متوسطة';
      case 'high':
        return 'عالية';
      case 'urgent':
        return 'عاجلة';
      default:
        return priority;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'low':
        return iOS26Colors.accentGreen;
      case 'medium':
        return iOS26Colors.accentOrange;
      case 'high':
        return iOS26Colors.accentRed;
      case 'urgent':
        return iOS26Colors.accentPurple;
      default:
        return iOS26Colors.textSecondary;
    }
  }
}

/// Individual Filter Chip
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
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 0.5,
        ),
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
            child: Icon(
              Icons.close,
              size: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Clear All Button
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
            Icon(
              Icons.clear_all,
              size: 16,
              color: iOS26Colors.accentRed,
            ),
            SizedBox(width: 4),
            Text(
              'مسح الكل',
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

/// iOS 26 Complaint Card
class _iOS26ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final int index;

  const _iOS26ComplaintCard({
    required this.complaint,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !complaint.isRead;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(
          AppRoutes.complaintDetails,
          arguments: {'id': complaint.id},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnread
                ? iOS26Colors.accentBlue.withOpacity(0.4)
                : iOS26Colors.borderPrimary.withOpacity(0.3),
            width: isUnread ? 1.5 : 0.5,
          ),
          boxShadow: isUnread
              ? [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Unread indicator bar
              if (isUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          iOS26Colors.accentBlue,
                          iOS26Colors.accentIndigo,
                        ],
                      ),
                    ),
                  ),
                ),
              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        // Complaint ID Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: iOS26Colors.accentBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            complaint.complaintId,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: iOS26Colors.accentBlue,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Unread dot
                        if (isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: iOS26Colors.accentBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: iOS26Colors.accentBlue.withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        // Status Badge
                        _StatusBadge(status: complaint.status),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Title
                    Text(
                      complaint.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                        color: iOS26Colors.textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      complaint.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: iOS26Colors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),

                    // Footer
                    Row(
                      children: [
                        // User
                        _InfoChip(
                          icon: Iconsax.user,
                          label: complaint.userFullName ?? 'مستخدم',
                        ),
                        const SizedBox(width: 16),
                        // Time
                        _InfoChip(
                          icon: Iconsax.clock,
                          label: Helpers.timeAgo(complaint.createdAt),
                        ),
                        const Spacer(),
                        // Priority
                        _PriorityBadge(priority: complaint.priority),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Info Chip (User, Time)
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: iOS26Colors.textTertiary,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: iOS26Colors.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// Status Badge
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color get _color {
    switch (status.toLowerCase()) {
      case 'pending':
        return iOS26Colors.statusPending;
      case 'in_progress':
        return iOS26Colors.statusInProgress;
      case 'resolved':
        return iOS26Colors.statusResolved;
      case 'closed':
        return iOS26Colors.statusClosed;
      default:
        return iOS26Colors.textTertiary;
    }
  }

  String get _label {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'in_progress':
        return 'قيد المعالجة';
      case 'resolved':
        return 'تم الحل';
      case 'closed':
        return 'مغلقة';
      default:
        return status;
    }
  }

  IconData get _icon {
    switch (status.toLowerCase()) {
      case 'pending':
        return Iconsax.clock;
      case 'in_progress':
        return Iconsax.refresh;
      case 'resolved':
        return Iconsax.tick_circle;
      case 'closed':
        return Iconsax.close_circle;
      default:
        return Iconsax.info_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: 12,
            color: _color,
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Priority Badge
class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  Color get _color {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return iOS26Colors.accentRed;
      case 'medium':
        return iOS26Colors.accentOrange;
      case 'low':
        return iOS26Colors.accentGreen;
      default:
        return iOS26Colors.textTertiary;
    }
  }

  String get _label {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'عالية';
      case 'urgent':
        return 'عاجلة';
      case 'medium':
        return 'متوسطة';
      case 'low':
        return 'منخفضة';
      default:
        return priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

/// iOS 26 Filter Bottom Sheet
class _iOS26FilterSheet extends StatelessWidget {
  final ComplaintsController controller;

  const _iOS26FilterSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                    'تصفية الشكاوى',
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

            // Status Section
            _FilterSection(
              title: 'الحالة',
              child: Obx(() => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _FilterOption(
                    label: 'قيد الانتظار',
                    color: iOS26Colors.statusPending,
                    isSelected: controller.statusFilter.value == 'pending',
                    onTap: () => controller.setStatusFilter(
                      controller.statusFilter.value == 'pending'
                          ? null
                          : 'pending',
                    ),
                  ),
                  _FilterOption(
                    label: 'قيد المعالجة',
                    color: iOS26Colors.statusInProgress,
                    isSelected:
                    controller.statusFilter.value == 'in_progress',
                    onTap: () => controller.setStatusFilter(
                      controller.statusFilter.value == 'in_progress'
                          ? null
                          : 'in_progress',
                    ),
                  ),
                  _FilterOption(
                    label: 'تم الحل',
                    color: iOS26Colors.statusResolved,
                    isSelected: controller.statusFilter.value == 'resolved',
                    onTap: () => controller.setStatusFilter(
                      controller.statusFilter.value == 'resolved'
                          ? null
                          : 'resolved',
                    ),
                  ),
                  _FilterOption(
                    label: 'مغلقة',
                    color: iOS26Colors.statusClosed,
                    isSelected: controller.statusFilter.value == 'closed',
                    onTap: () => controller.setStatusFilter(
                      controller.statusFilter.value == 'closed'
                          ? null
                          : 'closed',
                    ),
                  ),
                ],
              )),
            ),

            const SizedBox(height: 20),

            // Priority Section
            _FilterSection(
              title: 'الأولوية',
              child: Obx(() => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _FilterOption(
                    label: 'منخفضة',
                    color: iOS26Colors.accentGreen,
                    isSelected: controller.priorityFilter.value == 'low',
                    onTap: () => controller.setPriorityFilter(
                      controller.priorityFilter.value == 'low'
                          ? null
                          : 'low',
                    ),
                  ),
                  _FilterOption(
                    label: 'متوسطة',
                    color: iOS26Colors.accentOrange,
                    isSelected: controller.priorityFilter.value == 'medium',
                    onTap: () => controller.setPriorityFilter(
                      controller.priorityFilter.value == 'medium'
                          ? null
                          : 'medium',
                    ),
                  ),
                  _FilterOption(
                    label: 'عالية',
                    color: iOS26Colors.accentRed,
                    isSelected: controller.priorityFilter.value == 'high',
                    onTap: () => controller.setPriorityFilter(
                      controller.priorityFilter.value == 'high'
                          ? null
                          : 'high',
                    ),
                  ),
                  _FilterOption(
                    label: 'عاجلة',
                    color: iOS26Colors.accentPurple,
                    isSelected: controller.priorityFilter.value == 'urgent',
                    onTap: () => controller.setPriorityFilter(
                      controller.priorityFilter.value == 'urgent'
                          ? null
                          : 'urgent',
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

/// Filter Section
class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

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

/// Filter Option
class _FilterOption extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : iOS26Colors.surfaceGlass,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.5)
                : iOS26Colors.borderPrimary.withOpacity(0.3),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Iconsax.tick_circle5,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
            ],
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

/// Loading State
class _iOS26LoadingState extends StatelessWidget {
  const _iOS26LoadingState();

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
            'جاري تحميل الشكاوى...',
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
class _iOS26EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _iOS26EmptyState({required this.onRefresh});

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
                Iconsax.message_text,
                color: iOS26Colors.textTertiary,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد شكاوى',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'لم يتم العثور على أي شكاوى مطابقة',
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