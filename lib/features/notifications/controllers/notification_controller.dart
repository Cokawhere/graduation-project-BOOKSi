import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
    _loadUnreadCount();
  }

  @override
  void onClose() {
    // Clean up any listeners if needed
    super.onClose();
  }

  // Refresh notifications when list view is opened
  void onListViewOpened() {
    // Just refresh the notifications list without marking them as read
    refreshNotifications();
    // Also refresh the unread count to ensure badge is accurate
    refreshUnreadCount();
  }

  // Manual mark all as read (for user action)
  Future<void> manualMarkAllAsRead() async {
    try {
      isLoading.value = true;
      await _notificationService.markAllAsRead();
      // Update local state
      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
      notifications.refresh();
      // Update unread count immediately
      unreadCount.value = 0;
      Get.snackbar('success'.tr, 'all_notifications_marked_read'.tr);
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_mark_all_read'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void _loadNotifications() {
    _notificationService.getNotifications().listen((notificationsList) {
      notifications.value = notificationsList;
      // Update unread count when notifications list changes
      _updateUnreadCountFromList(notificationsList);
    });
  }

  void _updateUnreadCountFromList(List<NotificationModel> notificationsList) {
    final unreadCount = notificationsList.where((n) => !n.isRead).length;
    this.unreadCount.value = unreadCount;
  }

  void _loadUnreadCount() {
    _notificationService.getUnreadCount().listen((count) {
      unreadCount.value = count;
    });
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      // Update local state
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        notifications.refresh();
        // Update unread count based on current notifications list
        _updateUnreadCountFromList(notifications);
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_mark_read'.tr);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      isLoading.value = true;
      await _notificationService.markAllAsRead();
      // Update local state
      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
      notifications.refresh();
      // Update unread count based on current notifications list
      _updateUnreadCountFromList(notifications);
      // Don't show snackbar for automatic marking when opening list
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_mark_all_read'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      notifications.removeWhere((n) => n.id == notificationId);
      // Update unread count based on current notifications list
      _updateUnreadCountFromList(notifications);
      Get.snackbar('success'.tr, 'notification_deleted'.tr);
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_delete'.tr);
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      isLoading.value = true;
      await _notificationService.deleteAllNotifications();
      notifications.clear();
      // Update unread count based on current notifications list
      _updateUnreadCountFromList(notifications);
      Get.snackbar('success'.tr, 'all_notifications_deleted'.tr);
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_delete_all'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get notification by ID
  NotificationModel? getNotificationById(String id) {
    try {
      return notifications.firstWhere((notification) => notification.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper method to get unread notifications
  List<NotificationModel> get unreadNotifications {
    return notifications.where((notification) => !notification.isRead).toList();
  }

  // Helper method to get read notifications
  List<NotificationModel> get readNotifications {
    return notifications.where((notification) => notification.isRead).toList();
  }

  // Helper method to format timestamp
  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Refresh notifications
  void refreshNotifications() {
    _loadNotifications();
    _loadUnreadCount();
  }

  // Force refresh unread count
  Future<void> refreshUnreadCount() async {
    try {
      final count = await _notificationService.getUnreadCountOnce();
      unreadCount.value = count;
    } catch (e) {
      // If there's an error, fall back to the stream
      _loadUnreadCount();
    }
  }

  // Refresh everything when app comes to foreground
  void onAppResume() {
    refreshNotifications();
    refreshUnreadCount();
  }

  // Force refresh notifications list (useful for real-time updates)
  void forceRefreshNotifications() {
    _loadNotifications();
  }
}
