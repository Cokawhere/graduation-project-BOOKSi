import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get notifications for current user
  Stream<List<NotificationModel>> getNotifications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get unread notifications count
  Stream<int> getUnreadCount() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(0);

    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Get unread notifications count (one-time query)
  Future<int> getUnreadCountOnce() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return 0;

    final snapshot = await _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    return snapshot.docs.length;
  }

  // Create a new notification
  Future<void> createNotification({
    required String receiverId,
    required String title,
    required NotificationType type,
    String? senderId,
    required String message,
  }) async {
    // Create the notification document directly in Firestore to ensure isRead is properly set
    await _firestore.collection('notifications').add({
      'receiverId': receiverId,
      'title': title,
      'type': type.toString().split('.').last,
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'isRead': false, // Explicitly set to false
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final unreadNotifications = await _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in unreadNotifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  // Delete all notifications for current user
  Future<void> deleteAllNotifications() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .get();

    for (final doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // Create book sold notification 
  Future<void> createBookSoldNotification({
    required String sellerId,
    required String bookTitle,
    required String buyerId,
  }) async {
    await createNotification(
      receiverId: sellerId,
      title: 'Book Sold Successfully!',
      type: NotificationType.bookSold,
      senderId: buyerId,
      message: 'Your book "$bookTitle" has been sold successfully.',
    );
  }

  // Create book request notification
  Future<void> createBookRequestNotification({
    required String userId,
    required String bookTitle,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    await createNotification(
      receiverId: userId,
      title: 'Someone wants to chat about your book!',
      type: NotificationType.bookRequest,
      senderId: currentUserId,
      message:
          'A user is interested in your book "$bookTitle" and wants to discuss it with you. Check your messages!',
    );
  }

  // Create book approved notification
  Future<void> createBookApprovedNotification({
    required String userId,
    required String bookTitle,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    await createNotification(
      receiverId: userId,
      title: 'Book Approved',
      type: NotificationType.bookApproved,
      senderId: currentUserId,
      message:
          'Your book "$bookTitle" has been approved and is now available for sale.',
    );
  }

  // Create book rejected notification
  Future<void> createBookRejectedNotification({
    required String userId,
    required String bookTitle,
    String? reason,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    final message = reason != null
        ? 'Your book "$bookTitle" has been rejected. Reason: $reason'
        : 'Your book "$bookTitle" has been rejected.';

    await createNotification(
      receiverId: userId,
      title: 'Book Rejected',
      type: NotificationType.bookRejected,
      senderId: currentUserId,
      message: message,
    );
  }

  // Test notification method
  Future<void> createTestNotification({
    required String userId,
    required String message,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    await createNotification(
      receiverId: userId,
      title: 'Test Notification',
      type: NotificationType.bookRequest,
      senderId: currentUserId,
      message: message,
    );
  }
}
