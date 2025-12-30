import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controllers/complaints_controller.dart';
import '../../utils/helpers.dart';

/// iOS 26 Inspired Complaint Details View
class ComplaintDetailsView extends StatefulWidget {
  const ComplaintDetailsView({super.key});

  @override
  State<ComplaintDetailsView> createState() => _ComplaintDetailsViewState();
}

class _ComplaintDetailsViewState extends State<ComplaintDetailsView> {
  final controller = Get.find<ComplaintsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      final complaintId = args?['id'] as String?;

      if (complaintId != null &&
          controller.selectedComplaint.value?.id != complaintId) {
        controller.loadComplaintDetails(complaintId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iOS26Colors.backgroundPrimary,
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.selectedComplaint.value == null) {
          return const _LoadingState();
        }

        final complaint = controller.selectedComplaint.value;
        if (complaint == null) {
          return const _NotFoundState();
        }

        // Mark as read
        if (!complaint.isRead) {
          controller.markAsRead(complaint.id!);
        }

        return Stack(
          children: [
            // Content
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _iOS26Header(
                    complaint: complaint,
                    onMenuAction: _handleMenuAction,
                  ),
                ),
                // Content
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 160),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Status Card
                      _StatusCard(complaint: complaint),
                      const SizedBox(height: 16),

                      // Details Card
                      _DetailsCard(complaint: complaint),
                      const SizedBox(height: 16),

                      // Images Section
                      if (complaint.images.isNotEmpty) ...[
                        _ImagesSection(
                          complaint: complaint,
                          onImageTap: (index) =>
                              _showImageViewer(complaint.images, index),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // User Info Card
                      _UserInfoCard(complaint: complaint),
                      const SizedBox(height: 16),

                      // Timeline Card
                      _TimelineCard(complaint: complaint),
                    ]),
                  ),
                ),
              ],
            ),

            // Bottom Actions
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomActions(
                complaintId: complaint.id!,
                onStatusTap: () => _showStatusBottomSheet(complaint.id!),
                onAssignTap: () => _showAssignDialog(complaint.id!),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _handleMenuAction(String action) {
    final complaint = controller.selectedComplaint.value;
    if (complaint == null) return;

    switch (action) {
      case 'status':
        _showStatusBottomSheet(complaint.id!);
        break;
      case 'assign':
        _showAssignDialog(complaint.id!);
        break;
      case 'delete':
        _showDeleteConfirmation(complaint.id!);
        break;
    }
  }

  void _showStatusBottomSheet(String id) {
    HapticFeedback.mediumImpact();
    Get.bottomSheet(
      _StatusBottomSheet(
        complaintId: id,
        onStatusSelected: (status) {
          Get.back();
          controller.updateComplaintStatus(id, status);
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _showAssignDialog(String id) {
    HapticFeedback.mediumImpact();

    // استخراج ID المسؤول المعين حالياً
    final complaint = controller.selectedComplaint.value;
    String? currentAssignedToId;

    if (complaint?.assignedTo != null) {
      if (complaint!.assignedTo is String) {
        currentAssignedToId = complaint.assignedTo as String;
      } else {
        // إذا كان UserModel
        currentAssignedToId = complaint.assignedTo?.id;
      }
    }

    Get.bottomSheet(
      _AssignAdminBottomSheet(
        complaintId: id,
        currentAssignedTo: currentAssignedToId,
        onAssigned: () {
          // إعادة تحميل تفاصيل الشكوى
          controller.loadComplaintDetails(id);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showDeleteConfirmation(String id) {
    HapticFeedback.mediumImpact();
    Get.dialog(
      _DeleteConfirmationDialog(
        onConfirm: () {
          Get.back();
          controller.deleteComplaint(id);
        },
      ),
    );
  }

  void _showImageViewer(List images, int index) {
    Get.dialog(
      _ImageViewerDialog(images: images, initialIndex: index),
      barrierColor: Colors.black87,
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

  static const Color statusPending = Color(0xFFFF9F0A);
  static const Color statusInProgress = Color(0xFF0A84FF);
  static const Color statusResolved = Color(0xFF30D158);
  static const Color statusClosed = Color(0xFF8E8E93);
}

/// iOS 26 Header
class _iOS26Header extends StatelessWidget {
  final dynamic complaint;
  final Function(String) onMenuAction;

  const _iOS26Header({
    required this.complaint,
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
            // Title & ID
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تفاصيل الشكوى',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: iOS26Colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    complaint.complaintId,
                    style: const TextStyle(
                      fontSize: 12,
                      color: iOS26Colors.textTertiary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
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
          color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
        ),
      ),
      itemBuilder: (context) => [
        _buildMenuItem('status', Iconsax.edit, 'تغيير الحالة', iOS26Colors.accentBlue),
        _buildMenuItem('assign', Iconsax.user_add, 'تعيين مسؤول', iOS26Colors.accentGreen),
        _buildMenuItem('delete', Iconsax.trash, 'حذف', iOS26Colors.accentRed),
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
              color: color.withValues(alpha: 0.15),
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

/// Status Card
class _StatusCard extends StatelessWidget {
  final dynamic complaint;

  const _StatusCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
    // استخدام message إذا كان title فارغاً
    final title = (complaint.title != null && complaint.title.toString().isNotEmpty)
        ? complaint.title
        : complaint.message ?? 'بدون عنوان';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A5F), Color(0xFF0F2744)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iOS26Colors.accentBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title أولاً
          Text(
            title.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: iOS26Colors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // Status & Priority Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusBadge(status: complaint.status ?? 'pending'),
              _PriorityBadge(priority: complaint.priority ?? 'medium'),
              if (complaint.categoryName != null && complaint.categoryName.toString().isNotEmpty)
                _CategoryBadge(category: complaint.categoryName!),
            ],
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _color),
          const SizedBox(width: 6),
          Text(
            _label,
            style: TextStyle(
              fontSize: 12,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
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
          const SizedBox(width: 6),
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

/// Category Badge
class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: iOS26Colors.accentTeal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: iOS26Colors.accentTeal,
        ),
      ),
    );
  }
}

/// Details Card
class _DetailsCard extends StatelessWidget {
  final dynamic complaint;

  const _DetailsCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
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
                  color: iOS26Colors.accentBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.document_text,
                  size: 18,
                  color: iOS26Colors.accentBlue,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'الوصف',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            complaint.description,
            style: const TextStyle(
              fontSize: 14,
              color: iOS26Colors.textSecondary,
              height: 1.7,
            ),
          ),
          // Location
          if (complaint.location != null && complaint.location!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _LocationButton(
              location: complaint.location!,
              locationName: complaint.locationName,
            ),
          ],
        ],
      ),
    );
  }
}

/// Location Button - يفتح Google Maps عند الضغط ويعرض اسم الموقع
class _LocationButton extends StatefulWidget {
  final String location; // الإحداثيات
  final String? locationName; // اسم الموقع (اختياري)

  const _LocationButton({
    required this.location,
    this.locationName,
  });

  @override
  State<_LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<_LocationButton> {
  String? _resolvedAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // إذا لم يكن هناك اسم موقع محفوظ، حاول جلبه من الإحداثيات
    if (widget.locationName == null || widget.locationName!.isEmpty) {
      _resolveAddress();
    }
  }

  /// تحويل الإحداثيات إلى عنوان باستخدام Geocoding
  Future<void> _resolveAddress() async {
    final coordsRegex = RegExp(r'(-?\d+\.?\d+)\s*,\s*(-?\d+\.?\d+)');
    final match = coordsRegex.firstMatch(widget.location);

    if (match != null) {
      final lat = match.group(1)!;
      final lng = match.group(2)!;

      setState(() => _isLoading = true);

      try {
        // استخدام Google Geocoding API أو Nominatim (مجاني)
        final url = Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&accept-language=ar'
        );

        final response = await http.get(url, headers: {
          'User-Agent': 'ComplaintsApp/1.0',
        });

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final address = data['display_name'] as String?;

          if (address != null && mounted) {
            // تقصير العنوان لعرض أهم المعلومات
            final shortAddress = _shortenAddress(data);
            setState(() {
              _resolvedAddress = shortAddress;
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  /// تقصير العنوان لعرض المعلومات الأهم
  String _shortenAddress(Map<String, dynamic> data) {
    final address = data['address'] as Map<String, dynamic>?;
    if (address == null) return data['display_name'] ?? widget.location;

    final parts = <String>[];

    // إضافة الأجزاء المهمة فقط
    if (address['road'] != null) parts.add(address['road']);
    if (address['neighbourhood'] != null) parts.add(address['neighbourhood']);
    if (address['suburb'] != null) parts.add(address['suburb']);
    if (address['city'] != null) parts.add(address['city']);
    if (address['town'] != null && address['city'] == null) parts.add(address['town']);
    if (address['state'] != null) parts.add(address['state']);

    if (parts.isEmpty) {
      return data['display_name'] ?? widget.location;
    }

    // أخذ أول 3 أجزاء فقط
    return parts.take(3).join('، ');
  }

  /// الحصول على العنوان للعرض
  String get displayAddress {
    if (widget.locationName != null && widget.locationName!.isNotEmpty) {
      return widget.locationName!;
    }
    return _resolvedAddress ?? widget.location;
  }

  Future<void> _openInMaps() async {
    HapticFeedback.lightImpact();

    try {
      String lat = '';
      String lng = '';

      final coordsRegex = RegExp(r'(-?\d+\.?\d+)\s*,\s*(-?\d+\.?\d+)');
      final match = coordsRegex.firstMatch(widget.location);

      if (match != null) {
        lat = match.group(1)!;
        lng = match.group(2)!;
      }

      Uri? mapsUri;

      if (lat.isNotEmpty && lng.isNotEmpty) {
        // فتح بالإحداثيات مباشرة
        mapsUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng');

        if (await canLaunchUrl(mapsUri)) {
          await launchUrl(mapsUri);
          return;
        }

        mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

        if (await canLaunchUrl(mapsUri)) {
          await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
          return;
        }

        mapsUri = Uri.parse('https://maps.apple.com/?q=$lat,$lng');

        if (await canLaunchUrl(mapsUri)) {
          await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
          return;
        }
      } else {
        final encodedLocation = Uri.encodeComponent(widget.location);

        mapsUri = Uri.parse('geo:0,0?q=$encodedLocation');

        if (await canLaunchUrl(mapsUri)) {
          await launchUrl(mapsUri);
          return;
        }

        mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedLocation');

        if (await canLaunchUrl(mapsUri)) {
          await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      Helpers.showErrorSnackbar('لا يمكن فتح تطبيق الخرائط');
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ في فتح الموقع');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openInMaps,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: iOS26Colors.surfaceGlass,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: iOS26Colors.accentOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iOS26Colors.accentOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Iconsax.location,
                size: 18,
                color: iOS26Colors.accentOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'الموقع',
                        style: TextStyle(
                          fontSize: 11,
                          color: iOS26Colors.textTertiary,
                        ),
                      ),
                      if (_isLoading) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: iOS26Colors.accentOrange,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: iOS26Colors.textPrimary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // عرض الإحداثيات أسفل العنوان إذا تم تحويلها
                  if (_resolvedAddress != null ||
                      (widget.locationName != null && widget.locationName!.isNotEmpty)) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        fontSize: 10,
                        color: iOS26Colors.textTertiary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: iOS26Colors.accentOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.export_3,
                    size: 14,
                    color: iOS26Colors.accentOrange,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'فتح',
                    style: TextStyle(
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
      ),
    );
  }
}

/// Images Section
class _ImagesSection extends StatelessWidget {
  final dynamic complaint;
  final Function(int) onImageTap;

  const _ImagesSection({
    required this.complaint,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
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
                  color: iOS26Colors.accentPurple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.image,
                  size: 18,
                  color: iOS26Colors.accentPurple,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'المرفقات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: iOS26Colors.accentPurple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${complaint.images.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: iOS26Colors.accentPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Images Grid
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: complaint.images.length,
              itemBuilder: (context, index) {
                final image = complaint.images[index];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onImageTap(index);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(left: index > 0 ? 12 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: CachedNetworkImage(
                        imageUrl: Helpers.getImageUrl(image.fileUrl),
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: iOS26Colors.surfaceGlass,
                          child: const Center(
                            child: Icon(
                              Iconsax.image,
                              color: iOS26Colors.textTertiary,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: iOS26Colors.surfaceGlass,
                          child: const Center(
                            child: Icon(
                              Iconsax.image,
                              color: iOS26Colors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// User Info Card
class _UserInfoCard extends StatelessWidget {
  final dynamic complaint;

  const _UserInfoCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
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
                  color: iOS26Colors.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.user,
                  size: 18,
                  color: iOS26Colors.accentGreen,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'معلومات المقدم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Info Items
          _InfoRow(
            icon: Iconsax.user,
            label: 'الاسم',
            value: complaint.userFullName ?? '-',
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Iconsax.calendar,
            label: 'تاريخ الإنشاء',
            value: Helpers.formatDateTime(complaint.createdAt),
          ),
          if (complaint.assignedToName != null) ...[
            const SizedBox(height: 14),
            _InfoRow(
              icon: Iconsax.user_tick,
              label: 'المسؤول المعين',
              value: complaint.assignedToName!,
              valueColor: iOS26Colors.accentGreen,
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
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iOS26Colors.textTertiary),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 13,
            color: iOS26Colors.textTertiary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? iOS26Colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Timeline Card
class _TimelineCard extends StatelessWidget {
  final dynamic complaint;

  const _TimelineCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
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
                  color: iOS26Colors.accentIndigo.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.timer_1,
                  size: 18,
                  color: iOS26Colors.accentIndigo,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'الجدول الزمني',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Timeline Items
          _TimelineItem(
            title: 'تم الإنشاء',
            date: Helpers.formatDateTime(complaint.createdAt),
            color: iOS26Colors.accentBlue,
            isFirst: true,
            isLast: complaint.resolvedAt == null && complaint.closedAt == null,
          ),
          if (complaint.resolvedAt != null)
            _TimelineItem(
              title: 'تم الحل',
              date: Helpers.formatDateTime(complaint.resolvedAt),
              color: iOS26Colors.accentGreen,
              isLast: complaint.closedAt == null,
            ),
          if (complaint.closedAt != null)
            _TimelineItem(
              title: 'تم الإغلاق',
              date: Helpers.formatDateTime(complaint.closedAt),
              color: iOS26Colors.statusClosed,
              isLast: true,
            ),
        ],
      ),
    );
  }
}

/// Timeline Item
class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, iOS26Colors.borderPrimary],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: iOS26Colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: iOS26Colors.textTertiary,
                ),
              ),
              if (!isLast) const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bottom Actions
class _BottomActions extends StatelessWidget {
  final String complaintId;
  final VoidCallback onStatusTap;
  final VoidCallback onAssignTap;

  const _BottomActions({
    required this.complaintId,
    required this.onStatusTap,
    required this.onAssignTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: iOS26Colors.surfaceElevated,
        border: Border(
          top: BorderSide(
            color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Status Button
            Expanded(
              child: GestureDetector(
                onTap: onStatusTap,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: iOS26Colors.surfaceGlass,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: iOS26Colors.borderPrimary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.edit,
                        size: 18,
                        color: iOS26Colors.textSecondary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'تغيير الحالة',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: iOS26Colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Assign Button
            Expanded(
              child: GestureDetector(
                onTap: onAssignTap,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [iOS26Colors.accentBlue, iOS26Colors.accentIndigo],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: iOS26Colors.accentBlue.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.user_add,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'تعيين مسؤول',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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

/// Status Bottom Sheet
class _StatusBottomSheet extends StatelessWidget {
  final String complaintId;
  final Function(String) onStatusSelected;

  const _StatusBottomSheet({
    required this.complaintId,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: iOS26Colors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
          // Title
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'تغيير حالة الشكوى',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
          ),
          // Status Options
          _StatusOption(
            status: 'pending',
            label: 'قيد الانتظار',
            icon: Iconsax.clock,
            color: iOS26Colors.statusPending,
            onTap: () => onStatusSelected('pending'),
          ),
          _StatusOption(
            status: 'in_progress',
            label: 'قيد المعالجة',
            icon: Iconsax.refresh,
            color: iOS26Colors.statusInProgress,
            onTap: () => onStatusSelected('in_progress'),
          ),
          _StatusOption(
            status: 'resolved',
            label: 'تم الحل',
            icon: Iconsax.tick_circle,
            color: iOS26Colors.statusResolved,
            onTap: () => onStatusSelected('resolved'),
          ),
          _StatusOption(
            status: 'closed',
            label: 'مغلقة',
            icon: Iconsax.close_circle,
            color: iOS26Colors.statusClosed,
            onTap: () => onStatusSelected('closed'),
          ),
          SafeArea(
            top: false,
            child: const SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}

/// Status Option
class _StatusOption extends StatelessWidget {
  final String status;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatusOption({
    required this.status,
    required this.label,
    required this.icon,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
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
                color: iOS26Colors.accentRed.withValues(alpha: 0.12),
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
              'حذف الشكوى',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: iOS26Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'هل أنت متأكد من حذف هذه الشكوى؟\nلا يمكن التراجع عن هذا الإجراء.',
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
                          'حذف',
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

/// Image Viewer Dialog
class _ImageViewerDialog extends StatelessWidget {
  final List images;
  final int initialIndex;

  const _ImageViewerDialog({
    required this.images,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: PageController(initialPage: initialIndex),
          itemCount: images.length,
          itemBuilder: (context, i) {
            return InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: Helpers.getImageUrl(images[i].fileUrl),
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
        // Close Button
        Positioned(
          top: 60,
          right: 20,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iOS26Colors.surfaceElevated.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
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
            'جاري تحميل التفاصيل...',
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
              Iconsax.document_text,
              color: iOS26Colors.textTertiary,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لم يتم العثور على الشكوى',
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
                color: iOS26Colors.accentBlue.withValues(alpha: 0.15),
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

/// ====================================================================
/// Assign Admin Bottom Sheet
/// ====================================================================

class _AssignAdminBottomSheet extends StatefulWidget {
  final String complaintId;
  final String? currentAssignedTo;
  final VoidCallback onAssigned;

  const _AssignAdminBottomSheet({
    required this.complaintId,
    this.currentAssignedTo,
    required this.onAssigned,
  });

  @override
  State<_AssignAdminBottomSheet> createState() => _AssignAdminBottomSheetState();
}

class _AssignAdminBottomSheetState extends State<_AssignAdminBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ComplaintsController _complaintsController = Get.find<ComplaintsController>();

  List<dynamic> _admins = [];
  List<dynamic> _filteredAdmins = [];
  bool _isLoading = true;
  String? _selectedAdminId;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    _selectedAdminId = widget.currentAssignedTo;
    _loadAdmins();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAdmins() async {
    try {
      setState(() => _isLoading = true);

      // جلب المسؤولين
      _admins = await _complaintsController.getAdminsForAssignment();
      _filteredAdmins = _admins;
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ في تحميل المسؤولين');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterAdmins(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAdmins = _admins;
      } else {
        _filteredAdmins = _admins.where((admin) {
          final name = admin.fullName?.toString().toLowerCase() ?? '';
          final id = admin.rationalId?.toString() ?? '';
          final phone = admin.phone?.toString() ?? '';
          return name.contains(query.toLowerCase()) ||
              id.contains(query) ||
              phone.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _assignAdmin() async {
    if (_selectedAdminId == null) {
      Helpers.showErrorSnackbar('يرجى اختيار مسؤول');
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isAssigning = true);

    try {
      await _complaintsController.assignComplaint(
        widget.complaintId,
        _selectedAdminId!,
      );

      Get.back();
      widget.onAssigned();
      Helpers.showSuccessSnackbar('تم تعيين المسؤول بنجاح');
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      setState(() => _isAssigning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: iOS26Colors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
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
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iOS26Colors.accentGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Iconsax.user_add,
                    color: iOS26Colors.accentGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تعيين مسؤول',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: iOS26Colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'اختر المسؤول لمعالجة هذه الشكوى',
                        style: TextStyle(
                          fontSize: 13,
                          color: iOS26Colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iOS26Colors.surfaceGlass,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: iOS26Colors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: iOS26Colors.surfaceGlass,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.search_normal,
                    size: 18,
                    color: iOS26Colors.textTertiary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterAdmins,
                      style: const TextStyle(
                        color: iOS26Colors.textPrimary,
                        fontSize: 15,
                      ),
                      cursorColor: iOS26Colors.accentBlue,
                      decoration: const InputDecoration(
                        hintText: 'بحث عن مسؤول...',
                        hintStyle: TextStyle(
                          color: iOS26Colors.textTertiary,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Admins List
          Expanded(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: iOS26Colors.accentBlue,
              ),
            )
                : _filteredAdmins.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: iOS26Colors.surfaceGlass,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Iconsax.user_search,
                      color: iOS26Colors.textTertiary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا يوجد مسؤولين',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: iOS26Colors.textPrimary,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredAdmins.length,
              itemBuilder: (context, index) {
                final admin = _filteredAdmins[index];
                final isSelected = _selectedAdminId == admin.id;

                return _AdminCard(
                  admin: admin,
                  isSelected: isSelected,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedAdminId = admin.id);
                  },
                );
              },
            ),
          ),

          // Bottom Actions
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: iOS26Colors.surfaceElevated,
              border: Border(
                top: BorderSide(
                  color: iOS26Colors.borderPrimary.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: iOS26Colors.surfaceGlass,
                        borderRadius: BorderRadius.circular(14),
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
                  flex: 2,
                  child: GestureDetector(
                    onTap: _selectedAdminId == null || _isAssigning
                        ? null
                        : _assignAdmin,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: _selectedAdminId != null && !_isAssigning
                            ? const LinearGradient(
                          colors: [
                            iOS26Colors.accentGreen,
                            Color(0xFF28B44B),
                          ],
                        )
                            : null,
                        color: _selectedAdminId == null || _isAssigning
                            ? iOS26Colors.surfaceGlass
                            : null,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _selectedAdminId != null && !_isAssigning
                            ? [
                          BoxShadow(
                            color: iOS26Colors.accentGreen.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : null,
                      ),
                      child: Center(
                        child: _isAssigning
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.tick_circle,
                              size: 20,
                              color: _selectedAdminId != null
                                  ? Colors.white
                                  : iOS26Colors.textTertiary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'تعيين المسؤول',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _selectedAdminId != null
                                    ? Colors.white
                                    : iOS26Colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
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

/// Admin Card
class _AdminCard extends StatelessWidget {
  final dynamic admin;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdminCard({
    required this.admin,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? iOS26Colors.accentGreen.withValues(alpha: 0.1)
              : iOS26Colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? iOS26Colors.accentGreen.withValues(alpha: 0.5)
                : iOS26Colors.borderPrimary.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iOS26Colors.accentPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  (admin.fullName?.toString() ?? 'A')[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: iOS26Colors.accentPurple,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    admin.fullName?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? iOS26Colors.accentGreen
                          : iOS26Colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.shield_tick,
                        size: 12,
                        color: iOS26Colors.accentPurple,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'مسؤول',
                        style: TextStyle(
                          fontSize: 12,
                          color: iOS26Colors.accentPurple,
                        ),
                      ),
                      if (admin.phone != null) ...[
                        const SizedBox(width: 12),
                        const Icon(
                          Iconsax.call,
                          size: 12,
                          color: iOS26Colors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          admin.phone.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: iOS26Colors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Selection Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? iOS26Colors.accentGreen : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? iOS26Colors.accentGreen
                      : iOS26Colors.borderPrimary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}