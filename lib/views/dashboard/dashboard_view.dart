import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/main_controller.dart';
import '../../utils/helpers.dart';
import '../../routes/app_routes.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: Obx(() {
        if (controller.isLoading.value && controller.complaintStats.value == null) {
          return const _iOS26LoadingView();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          color: iOS26Colors.accentBlue,
          backgroundColor: iOS26Colors.surfaceElevated,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Animated Header
              SliverToBoxAdapter(
                child: _iOS26Header(authController: authController),
              ),

              // Hero Stats Card
              SliverToBoxAdapter(
                child: _HeroStatsCard(controller: controller),
              ),

              // Quick Stats Grid
              SliverToBoxAdapter(
                child: _QuickStatsGrid(controller: controller),
              ),

              // Complaints Status Section
              SliverToBoxAdapter(
                child: _ComplaintsStatusCard(controller: controller),
              ),

              // Recent Complaints
              SliverToBoxAdapter(
                child: _RecentComplaintsSection(controller: controller),
              ),

              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// iOS 26 Color System
class iOS26Colors {
  // Backgrounds
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF0D0D0F);
  static const Color surfaceElevated = Color(0xFF1C1C1E);
  static const Color surfaceGlass = Color(0xFF2C2C2E);
  static const Color surfaceCard = Color(0xFF1A1A1C);

  // Accents
  static const Color accentBlue = Color(0xFF0A84FF);
  static const Color accentIndigo = Color(0xFF5E5CE6);
  static const Color accentPurple = Color(0xFFBF5AF2);
  static const Color accentTeal = Color(0xFF64D2FF);
  static const Color accentGreen = Color(0xFF30D158);
  static const Color accentOrange = Color(0xFFFF9F0A);
  static const Color accentRed = Color(0xFFFF453A);
  static const Color accentYellow = Color(0xFFFFD60A);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF48484A);

  // Borders & Dividers
  static const Color borderPrimary = Color(0xFF38383A);
  static const Color borderSubtle = Color(0xFF1D1D1F);
  static const Color divider = Color(0xFF2C2C2E);

  // Status Colors
  static const Color statusPending = Color(0xFFFF9F0A);
  static const Color statusInProgress = Color(0xFF0A84FF);
  static const Color statusResolved = Color(0xFF30D158);
  static const Color statusClosed = Color(0xFF8E8E93);
}

/// iOS 26 Loading View
class _iOS26LoadingView extends StatelessWidget {
  const _iOS26LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: iOS26Colors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: iOS26Colors.accentBlue,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'جاري التحميل...',
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

/// iOS 26 Header
class _iOS26Header extends StatelessWidget {
  final AuthController authController;

  const _iOS26Header({required this.authController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        20,
      ),
      child: Text(
        authController.currentUser.value?.fullName ?? 'المسؤول',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: iOS26Colors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

/// Hero Stats Card - Main Statistics
class _HeroStatsCard extends StatelessWidget {
  final DashboardController controller;

  const _HeroStatsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iOS26Colors.accentBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.message_text_1,
                    color: iOS26Colors.accentBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'إجمالي الشكاوى',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: iOS26Colors.textSecondary,
                    ),
                  ),
                ),
                // Pending indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: iOS26Colors.accentOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.clock,
                        size: 14,
                        color: iOS26Colors.accentOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.pendingComplaints} بانتظار',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: iOS26Colors.accentOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Main Value
            Text(
              Helpers.formatNumber(controller.totalComplaints),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: iOS26Colors.textPrimary,
                letterSpacing: -1,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'شكوى مسجلة في النظام',
              style: TextStyle(
                fontSize: 14,
                color: iOS26Colors.textSecondary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 20),
            // Mini stats row
            Row(
              children: [
                _MiniStat(
                  label: 'جديدة',
                  value: controller.pendingComplaints.toString(),
                  color: iOS26Colors.statusPending,
                ),
                const SizedBox(width: 24),
                _MiniStat(
                  label: 'قيد المعالجة',
                  value: controller.inProgressComplaints.toString(),
                  color: iOS26Colors.statusInProgress,
                ),
                const SizedBox(width: 24),
                _MiniStat(
                  label: 'تم الحل',
                  value: controller.resolvedComplaints.toString(),
                  color: iOS26Colors.statusResolved,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Mini Stat Widget
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: iOS26Colors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: iOS26Colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Quick Stats Grid
class _QuickStatsGrid extends StatelessWidget {
  final DashboardController controller;

  const _QuickStatsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'المستخدمين',
                  value: Helpers.formatNumber(controller.totalUsers),
                  subtitle: '${controller.activeUsers} نشط',
                  icon: Iconsax.people,
                  color: iOS26Colors.accentTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'التصنيفات',
                  value: Helpers.formatNumber(controller.totalCategories),
                  subtitle: 'تصنيف فعال',
                  icon: Iconsax.category,
                  color: iOS26Colors.accentPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'التقييمات',
                  value: Helpers.formatNumber(controller.totalRatings),
                  subtitle: 'متوسط ${controller.averageRating.toStringAsFixed(1)} ⭐',
                  icon: Iconsax.star_1,
                  color: iOS26Colors.accentYellow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'تم الحل',
                  value: Helpers.formatNumber(controller.resolvedComplaints),
                  subtitle: 'شكوى محلولة',
                  icon: Iconsax.tick_circle,
                  color: iOS26Colors.accentGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual Stat Card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isHighlighted;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted
              ? color.withOpacity(0.3)
              : iOS26Colors.borderPrimary.withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: isHighlighted
            ? [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 14),
          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: iOS26Colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: iOS26Colors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: iOS26Colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Complaints Status Card with Progress Bars
class _ComplaintsStatusCard extends StatelessWidget {
  final DashboardController controller;

  const _ComplaintsStatusCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: iOS26Colors.borderPrimary.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'حالات الشكاوى',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: iOS26Colors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: iOS26Colors.surfaceGlass,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'هذا الشهر',
                    style: TextStyle(
                      fontSize: 12,
                      color: iOS26Colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Status bars
            _StatusProgressBar(
              label: 'قيد الانتظار',
              count: controller.pendingComplaints,
              total: controller.totalComplaints,
              color: iOS26Colors.statusPending,
            ),
            const SizedBox(height: 16),
            _StatusProgressBar(
              label: 'قيد المعالجة',
              count: controller.inProgressComplaints,
              total: controller.totalComplaints,
              color: iOS26Colors.statusInProgress,
            ),
            const SizedBox(height: 16),
            _StatusProgressBar(
              label: 'تم الحل',
              count: controller.resolvedComplaints,
              total: controller.totalComplaints,
              color: iOS26Colors.statusResolved,
            ),
            const SizedBox(height: 16),
            _StatusProgressBar(
              label: 'مغلقة',
              count: controller.closedComplaints,
              total: controller.totalComplaints,
              color: iOS26Colors.statusClosed,
            ),
          ],
        ),
      ),
    );
  }
}

/// Status Progress Bar
class _StatusProgressBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatusProgressBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? count / total : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: iOS26Colors.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              '$count (${(percentage * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Progress bar with glow
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: iOS26Colors.surfaceGlass,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                width: MediaQuery.of(context).size.width * percentage * 0.75,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Recent Complaints Section
class _RecentComplaintsSection extends StatelessWidget {
  final DashboardController controller;

  const _RecentComplaintsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'أحدث الشكاوى',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  final mainController = Get.find<MainController>();
                  mainController.changePage(1);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: iOS26Colors.accentBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: iOS26Colors.accentBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Complaints list
          if (controller.recentComplaints.isEmpty)
            _EmptyComplaintsState()
          else
            ...controller.recentComplaints.asMap().entries.map(
                  (entry) => _ComplaintCard(
                complaint: entry.value,
                index: entry.key,
              ),
            ),
        ],
      ),
    );
  }
}

/// Empty State Widget
class _EmptyComplaintsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iOS26Colors.surfaceGlass,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Iconsax.message_text,
                color: iOS26Colors.textTertiary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد شكاوى حتى الآن',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: iOS26Colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'ستظهر الشكاوى الجديدة هنا',
              style: TextStyle(
                fontSize: 13,
                color: iOS26Colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual Complaint Card
class _ComplaintCard extends StatelessWidget {
  final dynamic complaint;
  final int index;

  const _ComplaintCard({
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread
                ? iOS26Colors.accentBlue.withOpacity(0.3)
                : iOS26Colors.borderPrimary.withOpacity(0.3),
            width: isUnread ? 1 : 0.5,
          ),
          boxShadow: isUnread
              ? [
            BoxShadow(
              color: iOS26Colors.accentBlue.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                // Unread indicator
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: iOS26Colors.accentBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: iOS26Colors.accentBlue.withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Text(
                    complaint.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                      color: iOS26Colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: complaint.status),
              ],
            ),
            const SizedBox(height: 10),
            // Complaint ID
            Text(
              complaint.complaintId,
              style: const TextStyle(
                fontSize: 12,
                color: iOS26Colors.textTertiary,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 10),
            // Footer
            Row(
              children: [
                const Icon(
                  Iconsax.clock,
                  size: 14,
                  color: iOS26Colors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  Helpers.timeAgo(complaint.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: iOS26Colors.textTertiary,
                  ),
                ),
                const Spacer(),
                _PriorityBadge(priority: complaint.priority),
              ],
            ),
          ],
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
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
      case 'urgent':
        return iOS26Colors.accentRed;
      case 'high':
        return iOS26Colors.accentOrange;
      case 'medium':
        return iOS26Colors.accentYellow;
      case 'low':
        return iOS26Colors.accentGreen;
      default:
        return iOS26Colors.textTertiary;
    }
  }

  String get _label {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 'عاجلة';
      case 'high':
        return 'عالية';
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
    return Row(
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
        const SizedBox(width: 6),
        Text(
          _label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _color,
          ),
        ),
      ],
    );
  }
}