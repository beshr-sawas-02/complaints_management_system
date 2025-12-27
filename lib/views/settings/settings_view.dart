// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../utils/app_colors.dart';
//
// class SettingsView extends StatelessWidget {
//   const SettingsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       appBar: AppBar(
//         title: const Text('الإعدادات'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Appearance Section
//             _buildSectionTitle('المظهر'),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Column(
//                 children: [
//                   _buildSwitchItem(
//                     icon: Iconsax.moon,
//                     title: 'الوضع الداكن',
//                     value: false,
//                     onChanged: (value) {
//                       // TODO: Implement dark mode
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Notifications Section
//             _buildSectionTitle('الإشعارات'),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Column(
//                 children: [
//                   _buildSwitchItem(
//                     icon: Iconsax.notification,
//                     title: 'إشعارات التطبيق',
//                     value: true,
//                     onChanged: (value) {
//                       // TODO: Implement notifications toggle
//                     },
//                   ),
//                   const Divider(height: 1),
//                   _buildSwitchItem(
//                     icon: Iconsax.message,
//                     title: 'إشعارات الشكاوى الجديدة',
//                     value: true,
//                     onChanged: (value) {
//                       // TODO: Implement
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // About Section
//             _buildSectionTitle('حول التطبيق'),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Column(
//                 children: [
//                   _buildMenuItem(
//                     icon: Iconsax.info_circle,
//                     title: 'حول التطبيق',
//                     subtitle: 'الإصدار 1.0.0',
//                     onTap: () {
//                       _showAboutDialog();
//                     },
//                   ),
//                   const Divider(height: 1),
//                   _buildMenuItem(
//                     icon: Iconsax.document,
//                     title: 'سياسة الخصوصية',
//                     onTap: () {
//                       // TODO: Open privacy policy
//                     },
//                   ),
//                   const Divider(height: 1),
//                   _buildMenuItem(
//                     icon: Iconsax.document_text,
//                     title: 'شروط الاستخدام',
//                     onTap: () {
//                       // TODO: Open terms
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 40),
//
//             // Copyright
//             Center(
//               child: Text(
//                 '© 2024 نظام إدارة الشكاوى',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: AppColors.textHint,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12, right: 4),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSwitchItem({
//     required IconData icon,
//     required String title,
//     required bool value,
//     required ValueChanged<bool> onChanged,
//   }) {
//     return ListTile(
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: AppColors.primary.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, size: 20, color: AppColors.primary),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       trailing: Switch(
//         value: value,
//         onChanged: onChanged,
//         activeColor: AppColors.primary,
//       ),
//     );
//   }
//
//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: AppColors.primary.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, size: 20, color: AppColors.primary),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       subtitle: subtitle != null
//           ? Text(
//         subtitle,
//         style: TextStyle(
//           fontSize: 12,
//           color: AppColors.textSecondary,
//         ),
//       )
//           : null,
//       trailing: Icon(
//         Icons.arrow_forward_ios,
//         size: 16,
//         color: AppColors.iconSecondary,
//       ),
//       onTap: onTap,
//     );
//   }
//
//   void _showAboutDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: const Row(
//           children: [
//             Icon(Iconsax.info_circle, color: AppColors.primary),
//             SizedBox(width: 8),
//             Text('حول التطبيق'),
//           ],
//         ),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'نظام إدارة الشكاوى',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'تطبيق لإدارة ومتابعة شكاوى المواطنين بشكل فعال وسريع.',
//               style: TextStyle(fontSize: 14),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'الإصدار: 1.0.0',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text('إغلاق'),
//           ),
//         ],
//       ),
//     );
//   }
// }