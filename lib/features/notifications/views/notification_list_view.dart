import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/styles/colors.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';
import 'notification_detail_view.dart';

class NotificationListView extends StatelessWidget {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    // Mark notifications as read when the view is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onListViewOpened();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'notifications'.tr,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.brown, size: 30),
          onPressed: () {
            // Refresh unread count when navigating back
            controller.refreshUnreadCount();
            Get.back();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.brown),
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  controller.manualMarkAllAsRead();
                  break;
                case 'delete_all':
                  _showDeleteAllDialog(context, controller);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read),
                    SizedBox(width: 8),
                    Text('mark_all_as_read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('delete_all', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: AppColors.olive,
                ),
                const SizedBox(height: 16),
                Text(
                  'no_notifications_yet'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.dark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'notifications_empty_message'.tr,
                  style: TextStyle(fontSize: 14, color: AppColors.teaMilk),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Force refresh to get latest notifications
            controller.forceRefreshNotifications();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _NotificationCard(
                notification: notification,
                controller: controller,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteAllDialog(
    BuildContext context,
    NotificationController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_all_notifications'.tr),
        content: Text('delete_all_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteAllNotifications();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final NotificationController controller;

  const _NotificationCard({
    required this.notification,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notification.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Only mark as read when user actually opens the notification
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
          Get.to(() => NotificationDetailView(notification: notification));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: notification.isRead ? AppColors.white : AppColors.background,
            border: notification.isRead
                ? Border.all(color: AppColors.olive.withOpacity(0.3))
                : Border.all(color: AppColors.brown.withOpacity(0.5), width: 2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(notification.type),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    notification.type.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.teaMilk,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          controller.formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.teaMilk,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          notification.type.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getTypeColor(notification.type),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete button
              IconButton(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                iconSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconBackgroundColor(NotificationType type) {
    switch (type) {
      case NotificationType.bookSold:
        return AppColors.orange.withOpacity(0.2);
      case NotificationType.bookRequest:
        return AppColors.brown.withOpacity(0.2);
      case NotificationType.bookApproved:
        return Colors.green.withOpacity(0.2);
      case NotificationType.bookRejected:
        return Colors.red.withOpacity(0.2);
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.bookSold:
        return AppColors.orange;
      case NotificationType.bookRequest:
        return AppColors.brown;
      case NotificationType.bookApproved:
        return Colors.green;
      case NotificationType.bookRejected:
        return Colors.red;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_notification'.tr),
        content: Text('delete_notification_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteNotification(notification.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}
