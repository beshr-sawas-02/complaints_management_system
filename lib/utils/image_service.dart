import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';
import 'helpers.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  // Pick single image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      final file = File(image.path);

      // Validate file size
      final fileSize = await file.length();
      if (fileSize > Constants.maxImageSize) {
        Helpers.showErrorSnackbar('حجم الصورة يجب أن يكون أقل من 5 ميجابايت');
        return null;
      }

      // Validate file type
      final extension = image.path.split('.').last.toLowerCase();
      if (!Constants.allowedImageTypes.contains(extension)) {
        Helpers.showErrorSnackbar('نوع الملف غير مدعوم. الأنواع المدعومة: jpg, jpeg, png');
        return null;
      }

      return file;
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ أثناء اختيار الصورة');
      return null;
    }
  }

  // Pick single image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      final file = File(image.path);

      // Validate file size
      final fileSize = await file.length();
      if (fileSize > Constants.maxImageSize) {
        Helpers.showErrorSnackbar('حجم الصورة يجب أن يكون أقل من 5 ميجابايت');
        return null;
      }

      return file;
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ أثناء التقاط الصورة');
      return null;
    }
  }

  // Pick multiple images
  static Future<List<File>> pickMultipleImages({int maxImages = 5}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isEmpty) return [];

      if (images.length > maxImages) {
        Helpers.showWarningSnackbar('يمكنك اختيار $maxImages صور كحد أقصى');
        images.removeRange(maxImages, images.length);
      }

      List<File> validFiles = [];
      for (var image in images) {
        final file = File(image.path);
        final fileSize = await file.length();

        if (fileSize <= Constants.maxImageSize) {
          final extension = image.path.split('.').last.toLowerCase();
          if (Constants.allowedImageTypes.contains(extension)) {
            validFiles.add(file);
          }
        }
      }

      if (validFiles.length < images.length) {
        Helpers.showWarningSnackbar('تم تجاهل بعض الصور غير الصالحة');
      }

      return validFiles;
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ أثناء اختيار الصور');
      return [];
    }
  }

  // Show image picker bottom sheet
  static Future<File?> showImagePickerBottomSheet() async {
    File? selectedFile;

    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'اختر صورة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  icon: Icons.photo_library_rounded,
                  label: 'المعرض',
                  onTap: () async {
                    Get.back();
                    selectedFile = await pickImageFromGallery();
                  },
                ),
                _buildPickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'الكاميرا',
                  onTap: () async {
                    Get.back();
                    selectedFile = await pickImageFromCamera();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );

    return selectedFile;
  }

  static Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.grey[700]),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get file size in readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}