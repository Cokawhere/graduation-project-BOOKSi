import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationModel {
  final String id;
  final String receiverId;
  final String title;
  final NotificationType type;
  final String? senderId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.title,
    required this.type,
    this.senderId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      receiverId: data['receiverId'] ?? '',
      title: data['title'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => NotificationType.bookSold,
      ),
      senderId: data['senderId'],
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'receiverId': receiverId,
      'title': title,
      'type': type.toString().split('.').last,
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? receiverId,
    String? title,
    NotificationType? type,
    String? senderId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      title: title ?? this.title,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType { bookSold, bookRequest, bookApproved, bookRejected }

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.bookSold:
        return 'book_sold'.tr;
      case NotificationType.bookRequest:
        return 'book_request'.tr;
      case NotificationType.bookApproved:
        return 'book_approved'.tr;
      case NotificationType.bookRejected:
        return 'book_rejected'.tr;
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.bookSold:
        return '💰';
      case NotificationType.bookRequest:
        return '📖';
      case NotificationType.bookApproved:
        return '✅';
      case NotificationType.bookRejected:
        return '❌';
    }
  }
}
