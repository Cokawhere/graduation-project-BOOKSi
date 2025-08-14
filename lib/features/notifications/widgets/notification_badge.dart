import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/styles/colors.dart';
import '../controllers/notification_controller.dart';
import '../views/notification_list_view.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Obx(() {
      final unreadCount = controller.unreadCount.value;

      return Stack(
        children: [
          IconButton(
            onPressed: () {
              Get.to(() => const NotificationListView());
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.brown,
              size: 28,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}
