// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../controllers/notifications_controller.dart';
// import '../../data/models/notification_model.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/helpers.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/loading_widget.dart';
// import '../../widgets/empty_widget.dart';
//
// class NotificationsView extends GetView<NotificationsController> {
//   const NotificationsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       appBar: AppBar(
//         title: const Text('الإشعارات'),
//         actions: [
//           IconButton(
//             onPressed: controller.refreshNotifications,
//             icon: const Icon(Iconsax.refresh),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: CustomSearchField(
//               controller: controller.searchController,
//               hint: 'بحث في الإشعارات...',
//               onChanged: controller.setSearchQuery,
//               onClear: () => controller.setSearchQuery(''),
//             ),
//           ),
//
//           // Notifications List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value && controller.notifications.isEmpty) {
//                 return const LoadingWidget();
//               }
//
//               if (controller.notifications.isEmpty) {
//                 return EmptyWidget(
//                   title: 'لا توجد إشعارات',
//                   subtitle: 'ستظهر الإشعارات هنا عند وصولها',
//                   icon: Iconsax.notification,
//                   buttonText: 'تحديث',
//                   onButtonPressed: controller.refreshNotifications,
//                 );
//               }
//
//               return RefreshIndicator(
//                 onRefresh: controller.refreshNotifications,
//                 color: AppColors.primary,
//                 child: ListView.builder(
//                   controller: controller.scrollController,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: controller.notifications.length +
//                       (controller.isLoadingMore.value ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     if (index == controller.notifications.length) {
//                       return const Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Center(child: LoadingWidget(size: 30)),
//                       );
//                     }
//                     return _buildNotificationCard(controller.notifications[index]);
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNotificationCard(NotificationModel notification) {
//     return Dismissible(
//       key: Key(notification.id ?? ''),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerLeft,
//         padding: const EdgeInsets.only(left: 20),
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: AppColors.error,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Icon(Iconsax.trash, color: Colors.white),
//       ),
//       onDismissed: (_) {
//         if (notification.id != null) {
//           controller.deleteNotification(notification.id!);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColors.border),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: _getNotificationColor(notification.type).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 _getNotificationIcon(notification.type),
//                 color: _getNotificationColor(notification.type),
//                 size: 22,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     notification.message,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.textPrimary,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time_rounded,
//                         size: 14,
//                         color: AppColors.textHint,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         Helpers.timeAgo(notification.createdAt),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.textHint,
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: _getNotificationColor(notification.type).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           _getNotificationTypeText(notification.type),
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             color: _getNotificationColor(notification.type),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   IconData _getNotificationIcon(String type) {
//     switch (type) {
//       case 'new_complaint':
//         return Iconsax.message_add;
//       case 'status_update':
//         return Iconsax.status;
//       case 'assignment':
//         return Iconsax.user_tick;
//       case 'rating':
//         return Iconsax.star;
//       default:
//         return Iconsax.notification;
//     }
//   }
//
//   Color _getNotificationColor(String type) {
//     switch (type) {
//       case 'new_complaint':
//         return AppColors.info;
//       case 'status_update':
//         return AppColors.primary;
//       case 'assignment':
//         return AppColors.success;
//       case 'rating':
//         return AppColors.warning;
//       default:
//         return AppColors.textSecondary;
//     }
//   }
//
//   String _getNotificationTypeText(String type) {
//     switch (type) {
//       case 'new_complaint':
//         return 'شكوى جديدة';
//       case 'status_update':
//         return 'تحديث الحالة';
//       case 'assignment':
//         return 'تعيين';
//       case 'rating':
//         return 'تقييم';
//       default:
//         return 'إشعار';
//     }
//   }
// }