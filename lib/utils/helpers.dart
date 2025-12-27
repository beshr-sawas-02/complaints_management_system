import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'constants.dart';

class Helpers {
  Helpers._();

  // ================ Image URL Helper ================
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';

    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Check if it's a complaint image (starts with cmp-)
    if (imagePath.startsWith('cmp-')) {
      return '${Constants.uploadsUrl}/complaints/$imagePath';
    }

    // Check if it's a profile image (starts with profile-)
    if (imagePath.startsWith('profile-')) {
      return '${Constants.uploadsUrl}/profiles/$imagePath';
    }

    // Default: return with base uploads URL
    return '${Constants.uploadsUrl}/$imagePath';
  }

  // ================ Date & Time Formatters ================
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat(Constants.displayDateFormat, 'ar').format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat(Constants.displayDateTimeFormat, 'ar').format(date);
  }

  static String formatTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat(Constants.timeFormat, 'ar').format(date);
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '-';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 7) {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  // ================ Status Helpers ================
  static String getComplaintStatusText(String status) {
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

  static Color getComplaintStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.statusPending;
      case 'in_progress':
        return AppColors.statusInProgress;
      case 'resolved':
        return AppColors.statusResolved;
      case 'closed':
        return AppColors.statusClosed;
      default:
        return AppColors.textSecondary;
    }
  }

  static Color getComplaintStatusBgColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warningLight;
      case 'in_progress':
        return AppColors.infoLight;
      case 'resolved':
        return AppColors.successLight;
      case 'closed':
        return AppColors.border;
      default:
        return AppColors.border;
    }
  }

  static IconData getComplaintStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'in_progress':
        return Icons.sync_rounded;
      case 'resolved':
        return Icons.check_circle_rounded;
      case 'closed':
        return Icons.lock_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  // ================ Priority Helpers ================
  static String getPriorityText(String priority) {
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

  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'low':
        return AppColors.priorityLow;
      case 'medium':
        return AppColors.priorityMedium;
      case 'high':
        return AppColors.priorityHigh;
      case 'urgent':
        return AppColors.priorityUrgent;
      default:
        return AppColors.textSecondary;
    }
  }

  static Color getPriorityBgColor(String priority) {
    switch (priority) {
      case 'low':
        return AppColors.successLight;
      case 'medium':
        return AppColors.warningLight;
      case 'high':
        return const Color(0xFFFFEDD5);
      case 'urgent':
        return AppColors.errorLight;
      default:
        return AppColors.border;
    }
  }

  // ================ User Type Helpers ================
  static String getUserTypeText(String userType) {
    switch (userType) {
      case 'admin':
        return 'مسؤول';
      case 'citizen':
        return 'مواطن';
      default:
        return userType;
    }
  }

  static Color getUserTypeColor(String userType) {
    switch (userType) {
      case 'admin':
        return AppColors.primary;
      case 'citizen':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  // ================ Notification Type Helpers ================
  static String getNotificationTypeText(String type) {
    switch (type) {
      case 'status_update':
        return 'تحديث الحالة';
      case 'new_comment':
        return 'تعليق جديد';
      default:
        return type;
    }
  }

  static IconData getNotificationTypeIcon(String type) {
    switch (type) {
      case 'status_update':
        return Icons.update_rounded;
      case 'new_comment':
        return Icons.comment_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  // ================ Snackbar Helpers ================
  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      'نجاح',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void showWarningSnackbar(String message) {
    Get.snackbar(
      'تنبيه',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  static void showInfoSnackbar(String message) {
    Get.snackbar(
      'معلومة',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // ================ Dialog Helpers ================
  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color confirmColor = AppColors.error,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static void showLoadingDialog({String? message}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message ?? 'جاري التحميل...'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // ================ Validation Helpers ================
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!RegExp(r'^[0-9]{10,}$').hasMatch(value)) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  static String? validateRationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرقم الوطني مطلوب';
    }
    if (value.length < 10) {
      return 'الرقم الوطني غير صحيح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < Constants.minPasswordLength) {
      return 'كلمة المرور يجب أن تكون ${Constants.minPasswordLength} أحرف على الأقل';
    }
    return null;
  }

  // ================ Number Formatters ================
  static String formatNumber(num? number) {
    if (number == null) return '0';
    return NumberFormat('#,###', 'ar').format(number);
  }

  static String formatPercentage(double? value) {
    if (value == null) return '0%';
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  static String getProfileImageUrl(String? filename) {
    if (filename == null || filename.isEmpty) return '';
    if (filename.startsWith('http')) return filename;
    return '${Constants.uploadsUrl}/profiles/$filename';
  }

  static String getComplaintImageUrl(String? filename) {
    if (filename == null || filename.isEmpty) return '';
    if (filename.startsWith('http')) return filename;
    return '${Constants.uploadsUrl}/complaints/$filename';
  }

  // ================ Text Truncation ================
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // ================ Rating Stars ================
  static List<Widget> buildRatingStars(double rating, {double size = 16}) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(Icon(Icons.star, color: AppColors.warning, size: size));
      } else if (i - 0.5 <= rating) {
        stars.add(Icon(Icons.star_half, color: AppColors.warning, size: size));
      } else {
        stars.add(Icon(Icons.star_border, color: AppColors.warning, size: size));
      }
    }
    return stars;
  }
}